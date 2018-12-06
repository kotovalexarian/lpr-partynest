# frozen_string_literal: true

class MembershipAppPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/membership_app/tracking
  def tracking
    membership_app = MembershipApp.find params[:id]

    MembershipAppMailer.with(membership_app: membership_app).tracking
  end
end
