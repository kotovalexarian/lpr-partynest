# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.has_many(*args)
    options = args.extract_options!
    options[:dependent] ||= :restrict_with_exception
    super(*args, options)
  end

  def self.has_one(*args)
    options = args.extract_options!
    options[:dependent] ||= :restrict_with_exception
    super(*args, options)
  end

  def self.pg_enum(name, values)
    enum name => values.map { |s| [s.to_sym, s.to_s] }.to_h
  end
end
