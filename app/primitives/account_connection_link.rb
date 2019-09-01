# frozen_string_literal: true

class AccountConnectionLink
  attr_reader :person

  def initialize(person)
    @person = person or raise
  end
end
