# frozen_string_literal: true

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

module Shoulda
  module Matchers
    module ActiveModel
      class ValidatePresenceOfMatcher < ValidationMatcher
        def secure_password_being_validated?
          return false unless defined?(
            ::ActiveModel::SecurePassword::InstanceMethodsOnActivation
          )

          @attribute == :password && @subject.class.ancestors.include?(
            ::ActiveModel::SecurePassword::InstanceMethodsOnActivation,
          )
        end
      end
    end
  end
end
