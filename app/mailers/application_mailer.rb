# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  default from: Rails.application.settings(:identity)[:noreply_email_contact]
end
