#encoding: utf-8
class Article < ActiveRecord::Base
  extend FriendlyId
  require 'nokogiri'
  include Concerns::Searchable
  include Concerns::Ownerable
  include Concerns::Randomizable
  include Concerns::Shortable
  include Concerns::Taggable
  include Concerns::Commentable
  include Concerns::Sortable
  include StatePattern::ActiveRecord
  include PublicActivity::Model
  include PgSearch

  acts_as_votable

  set_initial_state Initial

  sortable_fields({title: :VIEWS, sort_by: :impressions_count})

  is_impressionable counter_cache: true, unique: :ip_address

  friendly_id :title, use: [:slugged, :history, :finders]

  belongs_to :article_area
  belongs_to :article_type
  belongs_to :cycle
  has_many :images, dependent: :destroy

  pg_search_scope :search, against: [:title, :tags]

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :tmp_content, length: {maximum: 30000}

  delegate :correct_title, to: :cycle, prefix: true, allow_nil: true

  scope :last_news, lambda { |user, params = {}|
    joins(:article_type).where("state = 'Article::Approved' OR state = 'Article::Changed'").where("article_types.title = 'NEWS' OR to_news = true")
  }

  scope :popular, -> { unscoped.order(impressions_count: :desc).limit(2) }

  scope :by_area, lambda { |user, params = {}, area|
    scope = where("state = 'Article::Approved' OR state = 'Article::Changed'")
    if area.present?
      scope.where(article_area: area)
    else
      scope
    end
  }

  scope :non_approved, lambda { |user, params = {}| where(author: user, state: 'Article::Published') }

  scope :approved, lambda { |user, params = {}|
    where(author: user).where("state = 'Article::Approved' OR state: 'Article::Changed'").order(created_at: :desc)
  }

  scope :random, lambda { where("state = 'Article::Approved' OR state = 'Article::Changed'").order("RANDOM()") }

  scope :unprocessed, lambda { |user, params = {}| where(author: user).where("state NOT IN ?", ['Article::Approved']) }

  def tiny_content
    Sanitize.fragment(short_content).truncate(200)
  end

  def short_content
    body = Nokogiri::HTML(content).xpath("//body")
    content = body.xpath("node()[comment()=' unbebreak ']/preceding-sibling::*")
    content.present? ? content.to_html : body.xpath("//body/node()").to_html.gsub("\n", "")
  end

  def clean_content
    return nil if content.nil?
    Nokogiri::HTML(content).xpath("//body/node()").to_html
  end

  def get_logo_url
    logo.present? ? logo : first_image_src
  end

  def article?
    true
  end

  def article_area_id
    article_area.nil? ? ArticleArea.default_id : article_area.id
  end

  def article_type_id
    article_type.nil? ? ArticleType.default_id : article_type.id
  end

  def cycle_id
    if self.cycle.nil?
      author.cycles.where(title: :NO_CYCLE).first.id
    else
      self.cycle.id
    end
  end

  def correct_title
    title.truncate(40)
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
