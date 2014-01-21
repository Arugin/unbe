class User
  include Mongoid::Document
  include Mongoid::Slug
  rolify
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Randomizable
  include Mongo::Voter
  has_merit

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :default_cycles
  after_create :default_role
  after_create :default_gender

  field :name, type: String
  field :second_name, type: String
  field :first_name, type: String
  field :email, type: String
  field :encrypted_password, type: String, default: ""
  field :subscribed, type: Boolean, default: true

  ## Recoverable
  field :reset_password_token, :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count, :type => Integer, :default => 6
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at, :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip, :type => String

  # Confirmable
  field :confirmation_token, :type => String
  field :confirmed_at, :type => Time
  field :confirmation_sent_at, :type => Time

  field :from, type: String
  field :is_active, type: Boolean, :default => true
  field :userAvatar, type: String
  field :statusPoints, type: Integer
  field :about, type: String

  slug  :name, :history => true, reserve: ['admin', 'root']

  embeds_one :avatar, as: :imageable, class_name: 'Picture', :cascade_callbacks => true
  belongs_to :gender
  has_many :cycles, inverse_of: :author
  has_many :articles, dependent: :restrict, inverse_of: :author
  has_many :comments, dependent: :restrict
  has_many :galleries, dependent: :restrict, inverse_of: :author

  search_in :name, :email

  validates :name, presence: true, uniqueness: true,  length: {minimum: 3, maximum: 20}
  validates :second_name, length: {maximum: 20}
  validates :first_name, length: {maximum: 20}
  validates :from, length: {maximum: 30}
  validates :about, length: {maximum: 1000}

  validates_presence_of :email
  validates_presence_of :encrypted_password

  accepts_nested_attributes_for :avatar, class_name: 'Picture', :allow_destroy => true, :reject_if => lambda { |a| a[:file].blank? }

  attr_accessible :subscribed,:gender, :gender_id, :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at, :from, :first_name, :second_name, :about, :avatar, :avatar_attributes

  default_scope order_by(:created_at => :desc)
  scope :random,lambda {
    all.not_in(is_active: false)
  }

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
    self.articles.where isPublished: false
  end

  def unapproved_articles
    self.articles.any_of({isApproved: false},{isUpdated: true}).and({isPublished: true})
  end

  def last_comments
    self.comments.limit(10).desc(:created_at)
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
    self.gender.male?
  end

  def female?
    self.gender.female?
  end

  def unknown?
    self.gender.unknown?
  end

  def full_profile?
    self.first_name.present? && self.second_name.present? && self.avatar.present? && self.from.present? && !unknown?
  end

  protected

  def remove_all_roles
    unless roles.empty?
      roles.each do |role|
        self.revoke role.name
      end
      self.save
    end
  end

  def default_role
    self.add_role :USER
  end

  def default_cycles
    if self.name != 'Arugin'
      Cycle.create_default_cycles self
    end
  end

  def default_gender
    if self.name != 'Arugin'
      self.gender = Gender.find_by(name:'UNKNOWN')
      self.save
    end
  end

end
