class ArticleType < ActiveRecord::Base
  has_many :articles, dependent: :restrict_with_error

  def self.default_id
    where(title: :ARTICLE).first.id
  end
end
