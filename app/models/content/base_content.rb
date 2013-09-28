module Content
  class BaseContent
    include Mongoid::Document
    include Concerns::Randomizable
    include Mongoid::Timestamps
    include Concerns::Shortable
    include Concerns::Searchable
    include Concerns::Ownerable

    field :title, type: String
    field :src, type: String
    field :description, type: String
    field :approved_to_news, type: Boolean, default: false
    field :reviewed, type: Boolean, default: false

    validates :title, length: {maximum: 70}, allow_blank: true
    validates :description, length: {maximum: 1000}
    validates :src, presence: true
    #validates_format_of :src, with: /(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?(\w{10,})|/
    validate :youtube_or_vimeo_url

    belongs_to :contentable, polymorphic: true

    has_many :comments, dependent: :restrict, as: :commentable, class_name: 'Comment'

    scope :random, all.where(approved_to_news: true, reviewed: true)
    scope :non_approved, lambda { |user, params = {}|
      search_for(user,params).where(reviewed: false)
    }

    def youtube_or_vimeo_url
      return if(self.src =~ %r{\A(https?)://(www.)?(youtube\.com/watch\?v=|youtu\.be/)([A-Za-z0-9_-]*)(\&\S+)?.*})
      return if(self.src =~ %r{\Ahttp://(www.)?vimeo\.com/([A-Za-z0-9._%-]*)((\?|#)\S+)?})
      errors.add(:src, :invalid)
    end


  end
end