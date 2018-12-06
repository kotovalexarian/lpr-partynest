# frozen_string_literal: true

class ProcessNewMembershipApp
  include Interactor

  def call
    MembershipAppMailer.with(context).tracking.deliver_now
  end
end
