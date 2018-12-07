# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramBot do
  subject { create :telegram_bot }

  it { is_expected.to validate_presence_of :secret }
  it { is_expected.to validate_presence_of :api_token }

  describe '#username' do
    def allow_value(*)
      super.for :username
    end

    it { is_expected.to allow_value nil }

    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value ' ' }
    it { is_expected.not_to allow_value ' ' * rand(2..10) }

    it { is_expected.to allow_value Faker::Internet.username nil, %w[_] }
    it { is_expected.to allow_value 'foo123_456_BAR' }

    it { is_expected.not_to allow_value Faker::Internet.email }
    it { is_expected.not_to allow_value Faker::PhoneNumber.phone_number }
  end
end
