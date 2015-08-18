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
        map = %Q{
          function() {
            if(this.tags){
              this.tags.forEach(function(tag){
                emit(tag, 1)
              });
            }
          }
        }

        reduce = %Q{
          function(key, values) {
            var tag_count = 0 ;
            values.forEach(function(value) {
              tag_count += value;
            });
            return tag_count;
          }
        }

        tags = self
        tags = tags.where(scope) if scope.present?

        results = tags.unscoped.map_reduce(map, reduce).out(inline: true)

        begin
          return results.to_a.map!{ |item| { :name => item['_id'], :count => item['value'].to_i } }
        rescue => e
          return []
        end
      end

      def tagged_with(tags)
        tags = [tags] unless tags.is_a? Array
        criteria.in(:tags => tags)
      end

      def tag_list
        self.all_tags.collect{|tag| tag[:name]}
      end
    end

  end
end