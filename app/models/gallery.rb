class Gallery
  include Mongoid::Document
  include Concerns::Ownerable

  field :name, type: String
  field :description, type: String

  validates :name, length: {maximum: 70}
  validates :description, length: {maximum: 1000}

  embeds_many :contents, class_name: 'Content::BaseContent'

  has_many :comments, dependent: :restrict, as: :commentable, class_name: 'Comment'
end