# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountRole do
  it { is_expected.to belong_to :account }
  it { is_expected.to belong_to :role }

  pending '.active'
end
