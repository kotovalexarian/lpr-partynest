# frozen_string_literal: true

class ConfirmPassport
  include Interactor

  def call
    create_passport_confirmation
    confirm_passport
  end

  def create_passport_confirmation
    passport_confirmation =
      context.passport.passport_confirmations.build user: context.user

    context.fail! passport_confirmation: nil unless passport_confirmation.save

    context.passport_confirmation = passport_confirmation
  end

  def confirm_passport
    return unless context.passport.enough_confirmations?

    context.fail! unless context.passport.update confirmed: true
  end
end
