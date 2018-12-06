# frozen_string_literal: true

class MembershipApplicationMailer < ApplicationMailer
  before_action :set_membership_application

  def tracking
    mail(
      to:      @membership_application.email,
      subject: translate('membership_application_mailer.tracking.subject'),
    )
  end

private

  def set_membership_application
    @membership_application = params[:membership_application]
  end
end
