class Settings
  include Mongoid::Document

  embedded_in :user

  field :unlock_top_menu, type: Boolean, default: false
end