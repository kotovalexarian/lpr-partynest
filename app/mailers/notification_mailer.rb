# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def signed_in(email, session)
    @session = session

    mail to: email
  end
end
