# frozen_string_literal: true

class ProcessNewMembershipApplication
  include Interactor

  def call
    MembershipApplicationMailer.with(context).tracking.deliver_now
  end
end
