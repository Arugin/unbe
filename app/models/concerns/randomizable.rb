# You must implement random scope in your model before
# using this concern
module Concerns
  module Randomizable
    extend ActiveSupport::Concern

    module ClassMethods

      def random_entries(count)
        name.constantize.random.limit(count)
      end

      def random_entry
        random_entries(1).first
      end

    end

  end
end