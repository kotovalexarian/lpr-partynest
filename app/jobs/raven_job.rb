# frozen_string_literal: true

class RavenJob < ApplicationJob
  queue_as :default

  def perform(event)
    Raven.send_event event
  end
end
