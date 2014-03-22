class ArticleType
  include Mongoid::Document
  field :title, type: String

  has_many :articles, dependent: :restrict

  def self.default_id
    where(title: :ARTICLE).first.id
  end
end
