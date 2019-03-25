# frozen_string_literal: true

class PassportImageValidator < ImageValidator
  class Validation < Validation
    MAX_SIZE = 20.megabytes

    def max_size
      MAX_SIZE
    end
  end
end
