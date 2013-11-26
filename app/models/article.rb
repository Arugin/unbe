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
  include ActionView::Helpers::TextHelper
  include Mongo::Voteable

  is_impressionable counter_cache: true, :unique => :ip_address

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

  slug  :title, :history => true

  belongs_to :article_area
  belongs_to :article_type
  belongs_to :cycle
  has_many :comments, dependent: :restrict, as: :commentable, class_name: 'Comment'

  search_in :title, :tags

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :tmpContent, length: {maximum: 20000}

  default_scope order_by(:created_at => :desc)

  scope :last_news, lambda { |user, params = {}|
    search_for(user,params).not_in(is_garbage: true).any_of({article_type: ArticleType.where({title: "NEWS"}).first},{to_news: true}).order_by([:created_at, :desc]).and({isApproved: true})
  }
  scope :by_area, lambda { |user, params = {}, area|
    search_for(user,params).not_in(is_garbage: true).where(article_area: area).order_by([:created_at, :desc]).and({isApproved: true})
  }
  scope :non_approved, lambda { |user, params = {}|
    search_for(user,params).any_of({isApproved: false},{isUpdated: true}).and({isPublished: true})
  }
  scope :approved, lambda { |user, params = {}|
    search_for(user,params).not_in(is_garbage: true).where({isApproved: true}).order_by([:created_at, :desc])
  }

  scope :random,lambda {
    not_in(is_garbage: true).not_in(article_type: ArticleType.where({title: "NEWS"}).first).and({isApproved: true})
  }

  attr_protected :to_news, :baseRating, :isApproved, :rating, :system_tag, :script

  voteable self, :up => +1, :down => -1
  voteable Cycle, :up => +1, :down => -1

  def un_publish
    self.isPublished = false
    self.isUpdated = true
    self.save
  end

  def publish
    self.isPublished = true
    self.save
  end

  def approve_prepare
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
    ending = nil
    max_size = 200
    final_content = strip_tags(short_content)
    if final_content.size > max_size
      ending = '...'
    end
    "#{final_content[0..max_size]}#{ending}"
  end

  def short_content
    delimiters = ['<p><!-- unbebreak --></p>']
    beginIndex = 0
    endIndex = nil

    delimiters.each do |delimiter|
      endIndex = content.index delimiter
    end

    if endIndex.nil?
        return content
    end

    return content[beginIndex, endIndex]
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

  protected

  def first_image
    doc = Nokogiri::HTML(self.content)
    img = doc.xpath('//img').first
  end

end
