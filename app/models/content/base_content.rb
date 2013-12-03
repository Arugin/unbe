module Content
  class BaseContent
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Slug
    include Concerns::Randomizable
    include Concerns::Shortable
    include Concerns::Searchable
    include Concerns::Ownerable
    include Concerns::Taggable
    include Mongo::Voteable
    include ActionView::Helpers::TextHelper

    is_impressionable counter_cache: true, :unique => :ip_address

    field :title, type: String
    field :src, type: String
    field :description, type: String
    field :approved_to_news, type: Boolean, default: false
    field :reviewed, type: Boolean, default: false
    field :impressions_count, type: Integer, default: 0

    slug  :title, :history => true

    validates :title, length: {maximum: 70}, allow_blank: true
    validates :description, length: {maximum: 1500}
    validates :src, presence: true
    validate :youtube_or_vimeo_url

    search_in :title, :tags

    belongs_to :contentable, polymorphic: true

    has_many :comments, dependent: :destroy, as: :commentable, class_name: 'Comment'

    default_scope order_by(:created_at => :desc)
    scope :random, all.where(approved_to_news: true, reviewed: true)
    scope :non_approved, lambda { |user, params = {}|
      search_for(user,params).where(reviewed: false)
    }

    alias :content :description

    voteable self, :up => +1, :down => -1

    def youtube_or_vimeo_url
      return if(self.src =~ %r{\A(https?)://(www.)?(youtube\.com/watch\?v=|youtu\.be/)([A-Za-z0-9_-]*)(\&\S+)?.*})
      return if(self.src =~ %r{\Ahttp://(www.)?vimeo\.com/([A-Za-z0-9._%-]*)((\?|#)\S+)?})
      errors.add(:src, :invalid)
    end

    def tiny_content
      strip_tags self.description
    end

  end
end