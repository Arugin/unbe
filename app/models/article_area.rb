class ArticleArea
  include Mongoid::Document
  field :title, type: Symbol

  has_many :articles

  def self.default_id
    where(:title => :NO_AREA).first._id
  end
end
