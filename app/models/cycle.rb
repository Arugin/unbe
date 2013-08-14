class Cycle
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Privatable
  include Concerns::Ownerable

  field :title, type: String
  field :description, type: String

  has_many :articles

  search_in :title

  def ordered_articles
    articles.order_by([:created_at, :desc])
  end

  def correct_title
    if title == 'NO_CYCLE'
      I18n.t title
    else
      title
    end
  end

  def self.default_id
    where(:title => :NO_CYCLE).first._id
  end

end
