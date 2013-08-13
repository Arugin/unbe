class ArticleType
  include Mongoid::Document
  field :title, type: String

  has_many :articles

  def self.default_id
    where(:title => :ARTICLE).first._id
  end
end
