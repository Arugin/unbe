module Concerns
  module Sortable
    extend ActiveSupport::Concern

    included do
      class_attribute :SORTABLE_FIELDS
      self.SORTABLE_FIELDS = [:created_at, :title, :comments_count, :'votes.point']
    end

    module ClassMethods
      # Custom sortable items, array of items, each can be:
      # - symbol: will be sorted by this field, title will be humanized
      # - hash: {sort_by: :field, title: 'Custom title'}
      def sortable_fields(*fields)
        self.SORTABLE_FIELDS.concat fields
      end

      def can_be_sorted_by
        self.SORTABLE_FIELDS.map do |field|
          send "#{field.class.name.underscore}_item", field
        end
      end

      private

      def hash_item(field)
        {title: field[:title], sort_by: field[:sort_by]}
      end

      def symbol_item(field)
        {title: field.to_s.upcase, sort_by: field}
      end
    end

  end
end