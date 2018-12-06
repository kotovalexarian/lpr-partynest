# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role do
  subject { create :role }

  it { is_expected.to validate_presence_of :name }

  pending "add some examples to (or delete) #{__FILE__}"
end
