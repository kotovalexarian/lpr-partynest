# frozen_string_literal: true

class LogUserSession
  include Interactor

  def call
    Session.create!(
      account: context.user.account,
      logged_at: context.user.current_sign_in_at,
      ip_address: context.user.current_sign_in_ip,
    )
  end
end
