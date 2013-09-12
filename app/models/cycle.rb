class Cycle
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Ownerable

  field :title, type: String
  field :description, type: String
  field :system, type: Boolean, default: false

  has_many :articles

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :description, length: {maximum: 1000}

  search_in :title

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
