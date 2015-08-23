module Concerns
  module Commentable
    extend ActiveSupport::Concern

    included do
      has_many :comments, as: :commentable, dependent: :restrict_with_error
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