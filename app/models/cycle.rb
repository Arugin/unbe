class Cycle
  include Mongoid::Document
  field :title, type: String
  field :description, type: String

  belongs_to :author, class_name: "User"
  has_many :articles
end
