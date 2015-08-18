class Gallery < ActiveRecord::Base
  extend FriendlyId
  include Concerns::Ownerable
  include Concerns::Searchable
  include Concerns::Shortable
  include Concerns::Taggable
  include Concerns::Commentable
  include PublicActivity::Model
  include Concerns::Shortable
  include PgSearch

  tracked owner: Proc.new{ |controller, model| controller.current_user if controller.present? }, params: {title: :title}

  is_impressionable counter_cache: true, unique: :ip_address

  alias :title :name
  alias :correct_title :name

  validates :name, presence: true, length: {minimum:3,maximum: 70}
  validates :description, length: {maximum: 1000}

  friendly_id  :name, use: [:history, :slugged, :finders]

  has_many :contents, dependent: :destroy, as: :contentable
  accepts_nested_attributes_for :contents, reject_if: lambda { |b| b[:src].blank? }

  pg_search_scope :search, against: [:title, :tags]

  def gallery?
    true
  end

end