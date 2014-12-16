class CrewRole
  include Mongoid::Document

  delegate :first_name, :second_name, :last_name,  to: :man, prefix: false

  belongs_to :man
end