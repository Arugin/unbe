class Film
  include Mongoid::Document
  include Mongoid::Slug
  include Concerns::Commentable
  include Concerns::Searchable
  include Concerns::Taggable
  include Concerns::Sortable

  field :title, type: String
  field :description, type: String
  field :release_date, type: Date
  field :countries, type: Array
  field :budget, type: Integer
  field :duration, type: Integer

  has_and_belongs_to_many :directors
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :screenwriters
  has_and_belongs_to_many :producers
  has_and_belongs_to_many :operators
  has_and_belongs_to_many :composers
  has_and_belongs_to_many :painters
  has_and_belongs_to_many :genres
  has_many :reviews, class_name: 'Article', dependent: :restrict
  has_one :poster, dependent: :destroy, as: :imagable, class_name: 'Image'
  slug  :title, history: true

  search_in :title, :tags

end
