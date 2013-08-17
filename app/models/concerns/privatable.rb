module Concerns
  module Privatable
    extend ActiveSupport::Concern

    def self.included(base)
      base.class_eval do |klass|
        klass.field :private, :type => Boolean, :default => false

        #shows all objects for this user and all public objects of this class
        klass.scope :all_for, lambda { |user|
          if user.has_role?(:ADMIN)
            all
          else
            any_of({"$and" => [{:private => true}, {:owner => user}]}, {:private => false})
          end
        }

      end

    end

  end

end