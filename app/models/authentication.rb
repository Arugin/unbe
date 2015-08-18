class Authentication < ActiveRecord::Base
  field :user_id, type: Integer
  field :provider, type: String
  field :uid, type: String

  belongs_to :user
end