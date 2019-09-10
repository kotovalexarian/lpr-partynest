# frozen_string_literal: true

class LogUserSessionJob < ApplicationJob
  queue_as :default

  def perform(user_id, user_agent)
    user = User.find user_id
    LogUserSession.call user: user, user_agent: user_agent
  end
end
