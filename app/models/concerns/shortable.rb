module Concerns
  module Shortable
    def self.included(base)
      base.class_eval do |klass|

        define_method :short_title, lambda {
          if title.size > 25
            "#{title[0..25]}..."
          else
            title
          end
        }

      end
    end

  end
end