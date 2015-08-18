module Concerns
  module Commentable
    extend ActiveSupport::Concern

    included do
      has_many :comments, dependent: :restrict_with_error, as: :commentable, class_name: 'Comment', counter_cache: true
    end

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

    def comments_count
      comments.count
    end

  end
end