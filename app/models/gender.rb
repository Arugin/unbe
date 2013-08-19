class Gender
  include Mongoid::Document
  has_many :users, autosave: true

  field :name, type: String
end
