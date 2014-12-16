class Man
  include Mongoid::Document
  include Mongoid::Slug
  include Concerns::Searchable

  field :first_name, type: String
  field :second_name, type: String
  field :last_name, type: String
  field :birthday, type: String

  has_many :crew_roles, dependent: :destroy

  search_in :first_name, :second_name, :last_name
end
