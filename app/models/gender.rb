class Gender
  include Mongoid::Document
  has_many :users, autosave: true

  field :name, type: String

  def male?
    name == 'MALE'
  end

  def female?
    name == 'FEMALE'
  end

  def unknown?
    name == 'UNKNOWN'
  end
end
