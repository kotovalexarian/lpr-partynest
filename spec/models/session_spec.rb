# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session do
  subject { create :some_session }

  describe '#account' do
    it { is_expected.to belong_to(:account).required }

    it { is_expected.to validate_presence_of(:account).with_message(:required) }
  end

  describe '#ip_address' do
    it { is_expected.to validate_presence_of :ip_address }
  end
end
