# frozen_string_literal: true

class LogUserSessionJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find user_id
    LogUserSession.call user: user
  end
end
