#encoding: utf-8
class Article
  require 'nokogiri'

  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Ownerable
  include Concerns::Randomizable
  include Concerns::Shortable
  include Concerns::Taggable
  include Concerns::Commentable
  include Mongo::Voteable

  is_impressionable counter_cache: true, unique: :ip_address

  field :title, type: String
  field :logo, type: String
  field :content, type: String
  field :tmpContent, type: String
  field :script, type: String
  field :isPublished, type: Boolean, default: false
  field :isApproved, type: Boolean, default: false
  field :isUpdated, type: Boolean, default: false
  field :baseRating, type: Integer
  field :rating, type: Integer
  field :system_tag, type: Symbol
  field :is_garbage, type: Boolean, default: false
  field :to_news, type: Boolean, default: false
  field :impressions_count, type: Integer, default: 0

  slug  :title, history: true

  belongs_to :article_area
  belongs_to :article_type
  belongs_to :cycle

  search_in :title, :tags

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :tmpContent, length: {maximum: 20000}

  scope :last_news, lambda { |user, params = {}|
    search_for(user,params).not_in(is_garbage: true).any_of({article_type: ArticleType.where({title: "NEWS"}).first},{to_news: true}).order_by([:created_at, :desc]).and(isApproved: true)
  }

  scope :by_area, lambda { |user, params = {}, area|
    scope = search_for(user,params).not_in(is_garbage: true).and(isApproved: true)
    if area.present?
      scope.where(article_area: area)
    else
      scope
    end
  }

  scope :non_approved, lambda { |user, params = {}|
    search_for(user,params).any_of({isApproved: false},{isUpdated: true}).and(isPublished: true)
  }

  scope :approved, lambda { |user, params = {}|
    search_for(user,params).not_in(is_garbage: true).where(isApproved: true).order_by([:created_at, :desc])
  }

  scope :random, lambda {
    not_in(is_garbage: true).not_in(article_type: ArticleType.where(title: "NEWS").first).and(isApproved: true)
  }

  scope :unprocessed, lambda { |user, params = {}|
    unscoped.search_for(user, params).any_of({isApproved: false}, {:isPublished => false})
  }


  attr_protected :to_news, :baseRating, :isApproved, :rating, :system_tag, :script

  voteable self, up: +1, down: -1
  voteable Cycle, up: +1, down: -1

  def un_publish
    self.isPublished = false
    self.isUpdated = true
    self.save
  end

  def publish
    return if tmpContent.nil?
    self.isPublished = true
    self.save
  end

  def approve_prepare
    return if tmpContent.nil?
    self.isUpdated = false
    self.isApproved = true
    self.content = self.tmpContent
    self.tmpContent = nil
  end

  def approve
    approve_prepare
    self.is_garbage = false
    self.save
  end

  def to_garbage
    approve_prepare
    self.is_garbage = true
    self.save
  end

  def tiny_content
    truncate(strip_tags(short_content), length: 200, omission: '...')
  end

  def short_content
    doc = Nokogiri::HTML(content)
    break_line = doc.xpath("//p[comment()=' unbebreak ']").first
    end_index = break_line.present? ? content.index(break_line.to_s) : content.length
    truncate(content, length: end_index, omission: '')
  end

  def is_changed?
    !isPublished || !isApproved || isUpdated
  end

  def get_logo_url
     if logo.present?
       logo
     elsif first_image.present? and first_image['src'].index('http://').present?
       first_image['src']
     else
       nil
     end
  end

  def self.can_be_sorted_by
    [
      { title: :CREATED_AT, sort_by: :created_at},
      { title: :TITLE, sort_by: :title},
      { title: :VIEWS, sort_by: :impressions_count}
    ]
  end

  def article?
    true
  end

  def article_area_id
    article_area.nil? ? ArticleArea.default_id : article_area._id
  end

  def article_type_id
    article_type.nil? ? ArticleType.default_id : article_type._id
  end

  def cycle_id
    cycle.nil? ? author.cycles.where(title: :NO_CYCLE).first._id : cycle._id
  end

  protected

  def first_image
    doc = Nokogiri::HTML(content)
    doc.xpath('//img').first
  end

end
