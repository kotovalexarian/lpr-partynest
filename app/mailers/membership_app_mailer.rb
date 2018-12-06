# frozen_string_literal: true

class MembershipAppMailer < ApplicationMailer
  before_action :set_membership_app

  def tracking
    mail(
      to:      @membership_app.email,
      subject: translate('membership_app_mailer.tracking.subject'),
    )
  end

private

  def set_membership_app
    @membership_app = params[:membership_app]
  end
end
