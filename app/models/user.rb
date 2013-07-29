class User
  include Mongoid::Document

  field :name, type: String
  field :second_name, type: String
  field :email, type: String
  field :encrypted_password, type: String, default: ""

  field :from, type: String
  field :is_active, type: Boolean

  field :userAvatar, type: String
  field :statusPoints, type: Integer

  belongs_to :gender, class_name: "Gender"
  has_many :cycles
end
