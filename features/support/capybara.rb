# frozen_string_literal: true

module Capybara
  module Helpers
    class << self
      alias normalize_whitespace_with_warning normalize_whitespace

      def normalize_whitespace(*args)
        silence_warnings do
          normalize_whitespace_with_warning(*args)
        end
      end
    end
  end
end
