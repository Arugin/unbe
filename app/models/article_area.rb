class ArticleArea < ActiveRecord::Base
  has_many :articles, dependent: :restrict_with_error

  def self.default_id
    where(title: :NO_AREA).first.id
  end
end
