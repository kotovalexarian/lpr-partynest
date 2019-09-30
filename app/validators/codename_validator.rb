# frozen_string_literal: true

class CodenameValidator < ApplicationEachValidator
  class Validation < Validation
    CODENAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze

    MIN = 3
    MAX = 36

    def perform
      error! :blank if str_value.blank?
      error! :codename unless CODENAME_RE.match? value
      error! :too_short, count: MIN if str_value.length < MIN
      error! :too_long,  count: MAX if str_value.length > MAX
    end
  end
end
