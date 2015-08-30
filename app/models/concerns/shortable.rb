module Concerns
  module Shortable
    extend ActiveSupport::Concern

    def short_title
      title.truncate(25)
    end

  end
end