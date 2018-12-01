# frozen_string_literal: true

class ConfirmPassport
  include Interactor

  def call
    create_passport_confirmation
    confirm_passport
  end

  def create_passport_confirmation
    context.passport_confirmation =
      context.passport.passport_confirmations.build user: context.user

    context.fail! unless context.passport_confirmation.save
  end

  def confirm_passport
    return unless context.passport.enough_confirmations?

    context.fail! unless context.passport.update confirmed: true
  end
end
