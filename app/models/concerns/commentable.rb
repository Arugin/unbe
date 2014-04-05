module Concerns
  module Commentable
    extend ActiveSupport::Concern

    included do
      has_many :comments, dependent: :destroy, as: :commentable, class_name: 'Comment'
      field :comments_count, type: Integer, default: 0
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

  end
end