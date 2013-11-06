class Gallery
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Ownerable
  include Concerns::Searchable
  include Concerns::Shortable
  include Concerns::Taggable
  include Mongo::Voteable

  is_impressionable counter_cache: true, :unique => :ip_address

  field :name, type: String
  field :description, type: String
  field :impressions_count, type: Integer, default: 0

  validates :name, presence: true, length: {minimum:3,maximum: 70}
  validates :description, length: {maximum: 1000}

  has_many :contents, dependent: :destroy, as: :contentable, class_name: 'Content::BaseContent'
  accepts_nested_attributes_for :contents, :reject_if => lambda { |b| b[:src].blank? }

  has_many :comments, dependent: :destroy, as: :commentable, class_name: 'Comment'

  default_scope order_by(:created_at => :desc)

  search_in :name, :tags

  def title
    name
  end
end