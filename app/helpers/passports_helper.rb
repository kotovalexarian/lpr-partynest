# frozen_string_literal: true

module PassportsHelper
  def passport_series(value)
    value.to_s.rjust 4, '0'
  end

  def passport_number(value)
    value.to_s.rjust 6, '0'
  end
end
