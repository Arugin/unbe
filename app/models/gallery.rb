class Gallery
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Ownerable
  include Concerns::Searchable

  field :name, type: String
  field :description, type: String

  validates :name, presence: true, length: {maximum: 70}
  validates :description, length: {maximum: 1000}

  has_many :contents, as: :contentable, class_name: 'Content::BaseContent'
  accepts_nested_attributes_for :contents, :reject_if => lambda { |b| b[:src].blank? }

  has_many :comments, dependent: :restrict, as: :commentable, class_name: 'Comment'
end