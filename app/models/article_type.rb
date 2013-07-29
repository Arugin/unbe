class ArticleType
  include Mongoid::Document
  field :title, type: String

  has_many :articles
end
