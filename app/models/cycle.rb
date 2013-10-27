class Cycle
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Ownerable
  include Concerns::Shortable
  include Concerns::Taggable
  include Mongo::Voteable

  field :title, type: String
  field :description, type: String
  field :system, type: Boolean, default: false

  has_many :articles, dependent: :restrict
  has_many :comments, as: :commentable, class_name: 'Comment'

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :description, length: {maximum: 1000}

  default_scope order_by(:created_at => :desc)

  search_in :title, :tags

  def ordered_articles
    articles.order_by([:created_at, :desc])
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
    create ({:title => 'NO_CYCLE', :description =>"NO_CYCLE_DESC",:author => user, :system => true})
    create ({:title => 'ARCHIVE_CYCLE', :description =>"ARCHIVE_CYCLE_DESC",:author => user, :system => true})
  end

  def system?
    system
  end

end
