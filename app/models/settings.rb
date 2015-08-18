class Settings < ActiveRecord::Base
  belongs_to :user

  field :unlock_top_menu, type: Boolean, default: false
end