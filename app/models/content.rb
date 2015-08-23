class Content < ActiveRecord::Base
  extend FriendlyId
  include Concerns::Randomizable
  include Concerns::Shortable
  include Concerns::Searchable
  include Concerns::Ownerable
  include Concerns::Taggable
  include Concerns::Commentable
  include Concerns::Sortable
  include ActionView::Helpers::TextHelper
  include PublicActivity::Model
  include PgSearch

  acts_as_votable

  tracked owner: Proc.new{ |controller, model| controller.current_user if controller.present? }, params: {title: :title}

  sortable_fields title: :VIEWS, sort_by: :impressions_count

  is_impressionable counter_cache: true, unique: :ip_address

  friendly_id  :title,  use: [:history, :slugged, :finders]

  validates :title, presence: true, length: {maximum: 70}, allow_blank: true
  validates :description, length: {maximum: 1500}
  validates :src, presence: true
  validate :youtube_or_vimeo_url

  delegate :title, to: :contentable, prefix: true, allow_nil: true

  pg_search_scope :search, against: [:title, :tags]

  belongs_to :contentable, polymorphic: true

  scope :random, ->{ where(approved_to_news: true, reviewed: true).order("RANDOM()") }

  scope :non_approved, lambda { |user, params = {}| where(reviewed: false) }

  scope :approved, lambda { |user, params = {}| where(approved_to_news: true, reviewed: true) }

  alias_attribute :content, :description
  alias_attribute :correct_title, :title

  def youtube_or_vimeo_url
    return if(self.src =~ %r{\A(https?)://(www.)?(youtube\.com/watch\?v=|youtu\.be/)([A-Za-z0-9_-]*)(\&\S+)?.*})
    return if(self.src =~ %r{\Ahttp://(www.)?vimeo\.com/([A-Za-z0-9._%-]*)((\?|#)\S+)?})
    errors.add(:src, :invalid)
  end

  def tiny_content
    Sanitize.fragment(description)
  end

  def content?
    true
  end

end
