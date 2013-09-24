module Content
  class BaseContent
    include Mongoid::Document

    field :name, type: String
    field :description, type: String

    validates :name, length: {maximum: 70}
    validates :description, length: {maximum: 1000}

    embedded_in :gallery, polymorphic: true

    has_many :comments, dependent: :restrict, as: :commentable, class_name: 'Comment'
  end
end