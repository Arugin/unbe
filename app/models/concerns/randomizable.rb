module Concerns
  module Randomizable
    def self.included(base)
      base.class_eval do |klass|

        define_singleton_method :random_entries, lambda { |count|
          if klass.name == 'Article'
            (0..klass.without_news.count-1).sort_by{rand}.slice(0, count).collect! do |i|
              klass.without_news.skip(i).first
            end
          else
            (0..klass.count-1).sort_by{rand}.slice(0, count).collect! do |i|
              klass.skip(i).first
            end
          end
        }

        define_singleton_method :random_entry, lambda {
          random_entries(1).first
        }

      end
    end

  end
end