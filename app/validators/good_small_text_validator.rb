# frozen_string_literal: true

class GoodSmallTextValidator < GoodTextValidator
  class Validation < Validation
    MIN = 1
    MAX = 255

    def perform
      super
      error :too_short, count: MIN if str_value.length < MIN
      error :too_long,  count: MAX if str_value.length > MAX
    end
  end
end
