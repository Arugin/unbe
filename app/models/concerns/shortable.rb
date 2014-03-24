module Concerns
  module Shortable
    extend ActiveSupport::Concern

    def short_title
      truncate(title, length: 25, omission: '...')
    end

  end
end