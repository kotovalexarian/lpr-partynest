# frozen_string_literal: true

class ImageValidator < ApplicationEachValidator
  class Validation < Validation
    MAX_SIZE = 1.megabyte

    CONTENT_TYPES = %w[
      image/png
      image/jpeg
      image/gif
    ].freeze

    EXTENSIONS = %w[
      png
      jpg
      jpeg
      gif
    ].freeze

    def perform
      return unless value.attached?

      case value
      when ActiveStorage::Attached::One
        check value
      when ActiveStorage::Attached::Many
        value.attachments.each(&method(:check))
      else
        raise TypeError
      end
    end

    def check(item)
      check_format item
      check_ext item
      check_size item
    end

    def check_format(item)
      return if item.blob.content_type.in? CONTENT_TYPES

      error :image_format, content_type: item.blob.content_type
    end

    def check_ext(item)
      return if item.blob.filename.extension.in? EXTENSIONS

      error :image_ext, ext: item.blob.filename.extension
    end

    def check_size(item)
      error :image_size unless item.blob.byte_size <= max_size
    end

    def max_size
      MAX_SIZE
    end
  end
end
