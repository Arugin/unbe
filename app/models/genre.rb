class Genre
  include Mongoid::Document

  field :title, type: Symbol
  has_many :films, dependent: :restrict

end