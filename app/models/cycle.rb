class Cycle
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Concerns::Searchable
  include Concerns::Ownerable
  include Concerns::Sortable
  include Concerns::Shortable
  include Concerns::Taggable
  include Concerns::Commentable
  include Mongo::Voteable
  include PublicActivity::Model

  tracked owner: Proc.new{ |controller, model| controller.current_user if controller.present?}, params: {title: :correct_title}

  field :title, type: String
  field :description, type: String
  field :system, type: Boolean, default: false
  field :logo, type: String

  slug  :title, history: true

  has_many :articles, dependent: :restrict

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :description, length: {maximum: 1000}

  default_scope order_by(created_at: :desc)

  search_in :title, :tags

  voteable self, up: +1, down: -1

  def ordered_articles
    articles.order_by(created_at: :desc)
  end

  def correct_title
    if ['NO_CYCLE','ARCHIVE_CYCLE'].include? title
      I18n.t title
    else
      title
    end
  end

  def correct_description
    if ['NO_CYCLE_DESC','ARCHIVE_CYCLE_DESC'].include? description
      I18n.t description
    else
      description
    end
  end

  def self.create_default_cycles(user)
    create title: 'NO_CYCLE', description:"NO_CYCLE_DESC", author: user, system: true
    create title: 'ARCHIVE_CYCLE', description: "ARCHIVE_CYCLE_DESC", author: user, system: true
  end

  def system?
    system
  end

  def cycle?
    true
  end

  def get_logo_url
    if logo.blank?
      nil
    else
      logo
    end
  end

  def included_impressions
    self.articles.inject(0){|sum, article| sum += article.impressionist_count}
  end

end
