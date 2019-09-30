# frozen_string_literal: true

class CodenameValidator < ApplicationEachValidator
  class Validation < Validation
    CODENAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze

    MIN = 3
    MAX = 36

    def perform
      error! :blank if value.to_s.blank?
      error! :codename unless CODENAME_RE.match? value
      error! :too_short, count: MIN if value.to_s.length < MIN
      error! :too_long,  count: MAX if value.to_s.length > MAX
    end
  end
end
