# frozen_string_literal: true

class ApplicationEachValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    self.class::Validation.new(self, record, attribute, value).call
  end

  class Validation
    attr_reader :value

    delegate :options, to: :@validator

    def initialize(validator, record, attribute, value)
      @validator = validator
      @record    = record
      @attribute = attribute
      @value     = value
    end

    def call
      catch :stop_validating do
        perform
      end
    end

    def perform
      raise NotImplementedError, "#{self.class}#perform"
    end

    def error(*args)
      @record.errors.add @attribute, *args
    end

    def error!(*args)
      error(*args)
      throw :stop_validating
    end

    def str_value
      @str_value ||= String(value).dup.freeze
    end
  end
end
