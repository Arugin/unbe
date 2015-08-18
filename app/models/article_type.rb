class ArticleType < ActiveRecord::Base
  field :title, type: String

  has_many :articles, dependent: :restrict

  def self.default_id
    where(title: :ARTICLE).first.id
  end
end
