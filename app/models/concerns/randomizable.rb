# You must implement random scope in your model before
# using this concern
module Concerns
  module Randomizable
    extend ActiveSupport::Concern

    module ClassMethods

      def random_entries(count)
        (0..name.constantize.random.count-1).sort_by{rand}.slice(0, count).collect! do |i|
          name.constantize.random.skip(i).first
        end
      end

      def random_entry
          random_entries(1).first
      end

    end

  end
end