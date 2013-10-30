class Gender
  include Mongoid::Document
  has_many :users, autosave: true

  field :name, type: String

  def male?
    self.name == 'MALE'
  end

  def female?
    self.name == 'FEMALE'
  end

  def unknown?
    self.name == 'UNKNOWN'
  end
end
