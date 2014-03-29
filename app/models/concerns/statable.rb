module Concerns
  module Statable
    def self.included(base)
      base.class_eval do
        include StatePattern

        after_initialize :set_state_from_db

        def set_state_from_db
          set_state(state_string_as_class || self.class.initial_state_class)
        end

        def set_state_with_mongoid_attribute(state_class)
          set_state_without_mongoid_attribute(state_class)
          write_attribute(self.class.state_attribute, @current_state_instance.class.name)
        end
        alias_method_chain :set_state, :mongoid_attribute

        def state=(new_state_string)
          set_state(state_string_as_class(new_state_string))
        end

        def state_string_as_class(state_string = @attributes[self.class.state_attribute])
          state_string.camelize.constantize unless state_string.nil?
        end

        def self.state_attribute
          @state_attribute ||= "state"
        end

        def self.set_state_attribute(state_attr)
          @state_attribute = state_attr.to_s
        end
      end
    end
  end
end