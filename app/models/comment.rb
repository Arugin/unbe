class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  validates :content, presence: true, length: {minimum: 3, maximum: 1000}

  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
