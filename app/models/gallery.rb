class Gallery
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Ownerable
  include Concerns::Searchable
  include Concerns::Shortable
  include Mongo::Voteable

  is_impressionable

  field :name, type: String
  field :description, type: String

  validates :name, presence: true, length: {minimum:3,maximum: 70}
  validates :description, length: {maximum: 1000}

  has_many :contents, dependent: :destroy, as: :contentable, class_name: 'Content::BaseContent'
  accepts_nested_attributes_for :contents, :reject_if => lambda { |b| b[:src].blank? }

  has_many :comments, dependent: :destroy, as: :commentable, class_name: 'Comment'

  def title
    name
  end
end