class ArticleArea < ActiveRecord::Base
  field :title, type: Symbol

  has_many :articles, dependent: :restrict

  def self.default_id
    where(title: :NO_AREA).first._id
  end
end
