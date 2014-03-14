module Concerns
  module Commentable
    def self.included(base)
      base.class_eval do |klass|
        klass.has_many :comments, dependent: :destroy, as: :commentable, class_name: 'Comment'
      end
    end

    module InstanceMethods
      def article?
        false
      end

      def cycle?
        false
      end

      def gallery?
        false
      end

      def content?
        false
      end
    end

  end
end