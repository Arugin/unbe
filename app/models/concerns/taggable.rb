module Concerns
  module Taggable
    extend ActiveSupport::Concern

    def tag_list=(tags)
      self.tags = string2tags(tags)
    end

    def tag_list
      tags.join(", ") if tags
    end

    def tags
      super || []
    end

    def add_tags(tags)
      if (tags)
        self.tags |= string2tags(tags)
      end
    end

    private

    def string2tags(tags)
      tags.split(",").collect{ |t| t.strip }.delete_if{ |t| t.blank? }
    end

    module ClassMethods

      def all_tags(scope = {})
        pluck(:tags).flatten.uniq.compact
      end

      def tag_list
        all_tags
      end
    end

  end
end