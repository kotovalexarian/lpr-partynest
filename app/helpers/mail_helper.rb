# frozen_string_literal: true

module MailHelper
  def greeting_text(name)
    capture do
      concat translate :hello
      concat ', '
      concat name
      concat '!'
    end
  end
end
