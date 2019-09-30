# frozen_string_literal: true

class GoodTextValidator < ApplicationEachValidator
  class Validation < Validation
    GOOD_TEXT_RE = /\A[^\s](.*[^\s])?\z/.freeze

    def perform
      error :blank if str_value.blank?
      error :good_text unless GOOD_TEXT_RE.match? value
    end
  end
end
