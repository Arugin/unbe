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
  include Concerns::Sortable
  include Mongo::Voteable
  include Concerns::Statable
  include PublicActivity::Model

  set_initial_state Initial

  sortable_fields({title: :VIEWS, sort_by: :impressions_count})

  is_impressionable counter_cache: true, unique: :ip_address

  field :title, type: String
  field :logo, type: String
  field :content, type: String
  field :tmpContent, type: String
  field :script, type: String
  field :baseRating, type: Integer
  field :rating, type: Integer
  field :system_tag, type: Symbol
  field :to_news, type: Boolean, default: false
  field :impressions_count, type: Integer, default: 0
  field :state, type: String

  slug  :title, history: true

  belongs_to :article_area
  belongs_to :article_type
  belongs_to :cycle
  has_many :images, dependent: :destroy

  search_in :title, :tags

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :tmpContent, length: {maximum: 20000}

  delegate :correct_title, to: :cycle, prefix: true, allow_nil: true

  scope :last_news, lambda { |user, params = {}|
    search_for(user,params).any_of({'$and' => [{state: 'Article::Approved'}, {to_news: true}]}, {'$and' => [{state: 'Article::Approved'}, {article_type: ArticleType.where(title: "NEWS").first}]}, {'$and' => [{state: 'Article::Changed'}, {to_news: true}]}, {'$and' => [{state: 'Article::Changed'}, {article_type: ArticleType.where(title: "NEWS").first}]}).order_by([:created_at, :desc])
  }

  scope :by_area, lambda { |user, params = {}, area|
    scope = search_for(user,params).any_of({state: 'Article::Approved'},{state: 'Article::Changed'})
    if area.present?
      scope.where(article_area: area)
    else
      scope
    end
  }

  scope :non_approved, lambda { |user, params = {}|
    search_for(user,params).where(state: 'Article::Published')
  }

  scope :approved, lambda { |user, params = {}|
    search_for(user,params).any_of({state: 'Article::Approved'},{state: 'Article::Changed'}).order_by([:created_at, :desc])
  }

  scope :random, lambda {
    any_of({state: 'Article::Approved'},{state: 'Article::Changed'}).not_in(article_type: ArticleType.where(title: "NEWS").first)
  }

  scope :unprocessed, lambda { |user, params = {}|
    unscoped.search_for(user, params).not_in(state: 'Article::Approved')
  }

  #attr_protected :to_news, :baseRating, :rating, :system_tag, :script, :state

  voteable self, up: +1, down: -1
  voteable Cycle, up: +1, down: -1

  def tiny_content
    truncate(strip_tags(short_content), length: 200, omission: '...')
  end

  def short_content
    doc = Nokogiri::HTML(content)
    break_line = doc.xpath("//p[comment()=' unbebreak ']").first
    end_index = break_line.present? ? content.index(break_line.to_s) : content.length
    truncate(content.sub('<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">', ''), length: end_index, omission: '')
  end

  def get_logo_url
     first_image_src || logo
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

  def correct_title
    truncate(title, length: 40, omission: '...')
  end

  def upload_images
    doc = content_to_doc
    doc.xpath('//img').each do |image|
      unless image_exists? image['src']
        uploaded_image = image_from_url(image['src'])
        image.set_attribute("src" , uploaded_image.file.url) if uploaded_image.present?
      end
    end
    self.content = doc.to_s
  end

  def remove_redundant_images
    self.images.each do |image|
      image.destroy if content_images.detect{|content_image| content_image['src'] == image.file.url}.nil?
    end
  end

  protected

  def content_to_doc
    Nokogiri::HTML(content)
  end

  def first_image_src
    if images.first.present?
      images.first.file.url :thumb
    else
      image = content_images.first
      image['src'] if image.present? and image['src'].index('http://').present?
    end
  end

  def content_images
    doc = content_to_doc
    doc.xpath('//img')
  end

  def image_from_url(url)
    self.images.create file: open(url)
  rescue => e
    puts "Can not upload image from #{url} to #{title}"
  end

  def image_exists?(src)
    self.images.detect {|image| puts image.file.url; image.file.url == src}.present?
  end

end
