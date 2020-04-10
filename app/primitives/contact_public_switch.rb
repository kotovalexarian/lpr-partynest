# frozen_string_literal: true

class ContactPublicSwitch
  attr_reader :contact

  def initialize(contact)
    @contact = contact or raise
  end
end
