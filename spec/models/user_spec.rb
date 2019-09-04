# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { create(:usual_account).user }

  describe '#account' do
    it { is_expected.to belong_to(:account).required }

    it { is_expected.to validate_uniqueness_of :account }
  end
end
