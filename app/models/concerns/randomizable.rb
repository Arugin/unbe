# You must implement random scope in your model before
# using this concern
module Concerns
  module Randomizable
    def self.included(base)
      base.class_eval do |klass|

        define_singleton_method :random_entries, lambda { |count|
          (0..klass.random.count-1).sort_by{rand}.slice(0, count).collect! do |i|
            klass.random.skip(i).first
          end
        }

        define_singleton_method :random_entry, lambda {
          random_entries(1).first
        }

      end
    end

  end
end