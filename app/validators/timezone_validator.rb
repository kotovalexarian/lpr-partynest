# frozen_string_literal: true

class TimezoneValidator < ApplicationEachValidator
  class Validation < Validation
    TIMEZONE_RE = /\A-?\d\d:\d\d:00\z/.freeze

    def perform
      error! :timezone unless TIMEZONE_RE.match? value
    end
  end
end
