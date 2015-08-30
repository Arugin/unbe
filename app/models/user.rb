class User < ActiveRecord::Base
  include PgSearch
  extend FriendlyId
  include Concerns::Searchable
  include Concerns::Randomizable
  include PublicActivity::Model

  has_merit
  rolify
  acts_as_voter

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :default_cycles
  after_create :default_role
  after_create :default_gender
  after_create :add_settings
  after_create :record_activity

  friendly_id  :name,  use: [:history, :slugged, :finders]

  has_one :avatar, as: :imageable, class_name: 'Picture'
  belongs_to :gender
  has_many :cycles, inverse_of: :author, dependent: :destroy, foreign_key: 'user_id'
  has_many :articles, dependent: :restrict_with_error, inverse_of: :author, foreign_key: 'user_id'
  has_many :comments, dependent: :restrict_with_error
  has_many :galleries, dependent: :restrict_with_error, inverse_of: :author, foreign_key: 'user_id'
  has_many :contents, dependent: :restrict_with_error, inverse_of: :author, foreign_key: 'user_id'
  has_and_belongs_to_many :subscriptions,
                          class_name: 'User',
                          join_table: :subscriptions,
                          foreign_key: :user_id,
                          association_foreign_key: :subscription_id
  has_and_belongs_to_many :subscribers,
                          class_name: 'User',
                          join_table: :subscriptions,
                          foreign_key: :subscription_id,
                          association_foreign_key: :user_id
  has_one :settings, class_name: 'Settings', dependent: :destroy

  accepts_nested_attributes_for :settings
  accepts_nested_attributes_for :avatar, allow_destroy: true, reject_if: lambda { |a| a[:file].blank? }

  has_many :authentications, dependent: :destroy

  pg_search_scope :search, against:[:name, :email]

  validates :name, presence: true, uniqueness: true,  length: {minimum: 3, maximum: 20}
  validates :second_name, length: {maximum: 20}
  validates :first_name, length: {maximum: 20}
  validates :from, length: {maximum: 30}
  validates :about, length: {maximum: 1000}

  validates_presence_of :email
  validates_presence_of :encrypted_password

  scope :random, lambda { where('NOT is_active = false') }

  scope :active, lambda { where('NOT is_active = false') }

  scope :very_active, -> { User.joins('RIGHT JOIN merit_scores ON merit_scores.sash_id = users.sash_id
                                RIGHT JOIN merit_score_points ON merit_score_points.score_id = merit_scores.id')
                               .group('users.id', 'merit_scores.sash_id').order('SUM(num_points) DESC').limit(10) }

  def highest_role
    curr_role = nil
    roles.each do |role|
      curr_role = role
    end
    unless curr_role.nil?
      curr_role.name
    else
      :NO_ROLE
    end
  end

  def change_role(role)
    unless has_role? role
      remove_all_roles
      add_role role
      self.save
    end
  end

  def unpublished_articles
    self.articles.where("state = 'Article::Initial' OR state = 'Article::Changed'")
  end

  def unapproved_articles
    self.articles.where(state: 'Article::Published')
  end

  def active_for_authentication?
    super && is_active?
  end

  def inactive_message
    if !is_active?
      :blocked
    else
      super # Use whatever other message
    end
  end

  def is_active?
    self.is_active
  end

  def access
    self.is_active = !self.is_active
    self.save
  end

  def male?
    gender.male?
  end

  def female?
    gender.female?
  end

  def unknown?
    gender.unknown?
  end

  def full_profile?
    first_name.present? && second_name.present? && about.present? && from.present? && !unknown?
  end

  def full_actions?
    articles.present? && contents.present? && comments.present?
  end

  def full_name
    [ first_name, last_name ].filter(&:presence).compact.map(&:strip) * ' '
  end

  def all_resources_ids
    articles.map(&:id).concat(cycles.map(&:id)).concat(contents.map(&:id)).concat(galleries.map(&:id))
  end

  def subscribe(user)
    subscriptions << user
    save
  end

  def unsubscribe(user)
    subscriptions.delete user
    save
  end

  def subscribed?(user)
    subscriptions.find(user)
    true
  rescue => e
    false
  end

  ### OMNIAUTH ###

  def apply_omniauth(omniauth, confirmation)
    self.email = omniauth['info']['email'] if email.blank?
    # Check if email is already into the database => user exists
    apply_trusted_services(omniauth, confirmation) if self.new_record?
  end

  # Create a new user
  def apply_trusted_services(omniauth, confirmation)
    # Merge user_info && extra.user_info
    user_info = omniauth['info']
    if omniauth['extra'] && omniauth['extra']['raw_info']
      user_info.merge!(omniauth['extra']['raw_info'])
    end
    # try name or nickname
    if self.name.blank?
      self.name   = user_info['name']   unless user_info['name'].blank?
      self.name ||= user_info['nickname'] unless user_info['nickname'].blank?
      self.name ||= (user_info['first_name'] + " " + user_info['last_name']) unless
        user_info['first_name'].blank? || user_info['last_name'].blank?
    end
    if self.email.blank?
      self.email = user_info['email'] unless user_info['email'].blank?
    end
    self.first_name = user_info['first_name'] unless user_info['first_name'].blank?
    self.second_name = user_info['last_name'] unless user_info['last_name'].blank?
    # Set a random password for omniauthenticated users
    self.password, self.password_confirmation = Devise.friendly_token if self.password.blank?

    self.gender = Gender.find_by(name: user_info['gender'].upcase) if user_info['gender'].present?
    self.avatar = open(user_info['image']) if user_info['image'].present? rescue


    if confirmation
      self.confirmed_at, self.confirmation_sent_at = Time.now
    end
  end

  protected

  def remove_all_roles
    self.roles.delete_all
    save
  end

  def default_role
    self.add_role :USER
  end

  def add_settings
    self.create_settings
  end

  def default_cycles
    Cycle.create_default_cycles self
  end

  def default_gender
    if self.gender.nil?
      self.gender = Gender.find_by(name:'UNKNOWN')
      self.save
    end
  end

  def record_activity
    create_activity action: :create, owner: self
  end

end
