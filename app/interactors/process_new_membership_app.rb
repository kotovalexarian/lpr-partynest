# frozen_string_literal: true

class ProcessNewMembershipApp
  include Interactor

  def call
    MembershipAppMailer.with(context).tracking.deliver_now

    MembershipPool.find_each do |membership_pool|
      membership_pool.membership_apps << context.membership_app
    end
  end
end
