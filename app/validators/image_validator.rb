# frozen_string_literal: true

class ImageValidator < ApplicationEachValidator
  class Validation < Validation
    MAX_SIZE = 1.megabyte

    CONTENT_TYPES = %w[
      image/png
      image/jpeg
      image/gif
    ].freeze

    delegate :blob, to: :value

    delegate :content_type, :byte_size, to: :blob

    def perform
      return unless value.attached?

      unless content_type.in? CONTENT_TYPES
        error :image_format, content_type: content_type
      end

      error :image_size unless byte_size <= MAX_SIZE
    end
  end
end
