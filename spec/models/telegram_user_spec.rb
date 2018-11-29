# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramUser, type: :model do
  subject { create :telegram_user }

  it { is_expected.to validate_presence_of :remote_telegram_id }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.not_to validate_presence_of :last_name }
  it { is_expected.not_to validate_presence_of :username }
  it { is_expected.not_to validate_presence_of :language_code }

  describe '#last_name' do
    context 'when it is empty' do
      subject { create :telegram_user, last_name: '' }

      specify do
        expect(subject.last_name).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :telegram_user, last_name: '   ' }

      specify do
        expect(subject.last_name).to eq nil
      end
    end
  end

  describe '#username' do
    context 'when it is empty' do
      subject { create :telegram_user, username: '' }

      specify do
        expect(subject.username).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :telegram_user, username: '   ' }

      specify do
        expect(subject.username).to eq nil
      end
    end
  end

  describe '#language_code' do
    context 'when it is empty' do
      subject { create :telegram_user, language_code: '' }

      specify do
        expect(subject.language_code).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :telegram_user, language_code: '   ' }

      specify do
        expect(subject.language_code).to eq nil
      end
    end
  end
end
