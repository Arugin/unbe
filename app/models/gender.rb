class Gender < ActiveRecord::Base
  has_many :users

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
