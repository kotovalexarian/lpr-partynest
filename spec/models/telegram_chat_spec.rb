# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramChat do
  subject { create :telegram_chat }

  it { is_expected.to validate_presence_of :remote_id }
  it { is_expected.to validate_presence_of :chat_type }

  it { is_expected.not_to validate_presence_of :title }
  it { is_expected.not_to validate_presence_of :username }
  it { is_expected.not_to validate_presence_of :first_name }
  it { is_expected.not_to validate_presence_of :last_name }

  it { is_expected.to validate_uniqueness_of :remote_id }

  it do
    is_expected.to \
      validate_inclusion_of(:chat_type)
      .in_array(%w[private group supergroup channel])
  end
end
