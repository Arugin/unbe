module Concerns
  module Ownerable
    extend ActiveSupport::Concern

    included do
      belongs_to :author, class_name: 'User', foreign_key: 'user_id', counter_cache: true
      validates :author, presence: true

      #gives all objects that belong to the user
      scope :of, lambda { |user|
        where(author: user.id)
      }

        #gives all objects that not belong to the user
      scope :unowned, lambda { |user|
        not_in(author: user.id)
      }
    end

  end
end