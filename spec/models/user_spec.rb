# frozen_string_literal: true

require 'rails_helper'
require 'devise_two_factor/spec_helpers'

RSpec.describe User do
  subject { create(:usual_account).user }

  it_behaves_like 'two_factor_authenticatable'
  it_behaves_like 'two_factor_backupable'

  describe '#account' do
    it { is_expected.to belong_to(:account).required }

    it { is_expected.to validate_uniqueness_of :account }
  end
end
