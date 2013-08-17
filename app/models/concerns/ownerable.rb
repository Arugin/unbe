module Concerns
  module Ownerable
    def self.included(base)
      base.class_eval do |klass|

        klass.belongs_to(:author, class_name: 'User')
        klass.validates(:author, presence: true)

        #gives all objects that belong to the user
        klass.scope :of, lambda { |user|
          where(:author => user.id)
        }

      end
    end

  end
end