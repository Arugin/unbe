class User
  include Mongoid::Document

  field :name, type: String
  field :second_name, type: String
end
