class User
  include Mongoid::Document
  rolify
  include Mongoid::Timestamps



  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :assign_default_cycles
  after_create :default_role

  field :name, type: String
  field :second_name, type: String
  field :email, type: String
  field :encrypted_password, type: String, default: ""

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


  field :from, type: String
  field :is_active, type: Boolean

  field :userAvatar, type: String
  field :statusPoints, type: Integer

  belongs_to :gender, class_name: "Gender"
  has_many :cycles
  has_many :articles

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :encrypted_password

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

  def assign_default_cycles
    if self.name != 'Arugin'
      Cycle.create ({:title => 'NO_CYCLE', :description =>"NO_CYCLE_DESC",:author => self})
    end
    Cycle.create ({:title => 'ARCHIVE_CYCLE', :description =>"ARCHIVE_CYCLE_DESC",:author => self})
  end

  def default_role
    self.add_role :READER
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

  protected

  def remove_all_roles
    unless roles.empty?
      roles.each do |role|
        puts "remove",role.name
        self.revoke role.name
      end
      self.save
    end
  end

end
