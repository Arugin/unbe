module Concerns
  module Shortable
    extend ActiveSupport::Concern

    included do
      include ActionView::Helpers::TextHelper
    end

    def short_title
      truncate(title, length: 25, omission: '...')
    end

  end
end