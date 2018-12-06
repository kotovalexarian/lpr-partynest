# frozen_string_literal: true

class MembershipApplicationPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/membership_application/tracking
  def tracking
    membership_application = MembershipApplication.find params[:id]

    MembershipApplicationMailer.with(
      membership_application: membership_application,
    ).tracking
  end
end
