class User
  include Mongoid::Document
  include Mongoid::Slug
  rolify
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Randomizable
  include Mongo::Voter
  include PublicActivity::Model
  has_merit

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :default_cycles
  after_create :default_role
  after_create :default_gender
  after_create :add_settings
  after_create :record_activity

  field :name, type: String
  field :second_name, type: String
  field :first_name, type: String
  field :email, type: String
  field :encrypted_password, type: String, default: ''
  field :subscribed, type: Boolean, default: true
  field :comments_count, type: Integer, default: 0

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count, type: Integer, default: 6
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  # Confirmable
  field :confirmation_token, type: String
  field :confirmed_at, type: Time
  field :confirmation_sent_at, type: Time

  field :from, type: String
  field :is_active, type: Boolean, default: true
  field :userAvatar, type: String
  field :statusPoints, type: Integer
  field :about, type: String

  slug  :name, history: true, reserve: ['admin', 'root']

  embeds_one :avatar, as: :imageable, class_name: 'Picture', cascade_callbacks: true
  belongs_to :gender
  has_many :cycles, inverse_of: :author, dependent: :destroy
  has_many :articles, dependent: :restrict, inverse_of: :author
  has_many :comments, dependent: :restrict
  has_many :galleries, dependent: :restrict, inverse_of: :author
  has_many :contents, dependent: :restrict, inverse_of: :author, class_name: 'Content::BaseContent'
  has_and_belongs_to_many :subscriptions, class_name: 'User', inverse_of: :subscribers
  has_and_belongs_to_many :subscribers, class_name: 'User', inverse_of: :subscriptions
  embeds_one :settings, class_name: 'Settings'

  accepts_nested_attributes_for :settings, autobuild: true
  accepts_nested_attributes_for :avatar, class_name: 'Picture', allow_destroy: true, reject_if: lambda { |a| a[:file].blank? }

  has_many :authentications, dependent: :destroy

  search_in :name, :email

  validates :name, presence: true, uniqueness: true,  length: {minimum: 3, maximum: 20}
  validates :second_name, length: {maximum: 20}
  validates :first_name, length: {maximum: 20}
  validates :from, length: {maximum: 30}
  validates :about, length: {maximum: 1000}

  validates_presence_of :email
  validates_presence_of :encrypted_password

  default_scope lambda {
    order_by(created_at: :desc)
  }

  scope :random, lambda {
    all.not_in(is_active: false)
  }

  scope :active, lambda {
    all.not_in(is_active: false)
  }

  def self.very_active
    User.all.sort{|a, b| b.points <=> a.points}[0..10]
  end

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
    self.articles.any_of({state: 'Article::Initial'}, {state: 'Article::Changed'})
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
    articles.map(&:_id).concat(cycles.map(&:_id)).concat(contents.map(&:_id)).concat(galleries.map(&:_id))
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
    puts omniauth.to_json
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
    self.roles = nil
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
