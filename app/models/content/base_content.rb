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
    include Concerns::Commentable
    include Mongo::Voteable
    include ActionView::Helpers::TextHelper
    include PublicActivity::Model

    tracked owner: Proc.new{ |controller, model| controller.current_user if controller.present? }, params: {title: :title}

    is_impressionable counter_cache: true, :unique => :ip_address

    field :title, type: String
    field :src, type: String
    field :description, type: String
    field :approved_to_news, type: Boolean, default: false
    field :reviewed, type: Boolean, default: false
    field :impressions_count, type: Integer, default: 0

    slug  :title, :history => true

    validates :title, presence: true, length: {maximum: 70}, allow_blank: true
    validates :description, length: {maximum: 1500}
    validates :src, presence: true
    validate :youtube_or_vimeo_url

    delegate :title, to: :contentable, prefix: true, allow_nil: true

    search_in :title, :tags

    belongs_to :contentable, polymorphic: true

    default_scope order_by(:created_at => :desc)
    scope :random, all.where(approved_to_news: true, reviewed: true)
    scope :non_approved, lambda { |user, params = {}|
      search_for(user,params).where(reviewed: false)
    }

    scope :approved, lambda { |user, params = {}|
      unscoped.search_for(user,params).where(approved_to_news: true, reviewed: true).order_by(params[:sort_by].to_sym => params[:direction].to_sym)
    }

    alias :content :description
    alias :correct_title :title

    voteable self, up: +1, down: -1

    attr_protected :reviewed, :approved_to_news
    attr_accessible :title, :src, :description, :contentable_id

    def youtube_or_vimeo_url
      return if(self.src =~ %r{\A(https?)://(www.)?(youtube\.com/watch\?v=|youtu\.be/)([A-Za-z0-9_-]*)(\&\S+)?.*})
      return if(self.src =~ %r{\Ahttp://(www.)?vimeo\.com/([A-Za-z0-9._%-]*)((\?|#)\S+)?})
      errors.add(:src, :invalid)
    end

    def tiny_content
      strip_tags self.description
    end

    def content?
      true
    end

    def self.can_be_sorted_by
      [
          { title: :CREATED_AT, sort_by: :created_at},
          { title: :TITLE, sort_by: :title},
          { title: :VIEWS, sort_by: :impressions_count},
          { title: :SORT_COMMENTS_COUNT, sort_by: :comments_count},
          { title: :VOTES_COUNT, sort_by: :'votes.point'}
      ]
    end

  end
end