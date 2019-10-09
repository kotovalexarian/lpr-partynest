# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer do
  describe '#signed_in' do
    let(:mail) { described_class.signed_in email, session }

    let(:email) { Faker::Internet.email }
    let(:session) { create :some_session }

    it 'has subject' do
      expect(mail.subject).to eq '[LPR Alert]: Произведён вход в ваш аккаунт'
    end

    it 'has source' do
      expect(mail.from).to eq ['no-reply@libertarian-party.com']
    end

    it 'has destination' do
      expect(mail.to).to eq [email]
    end

    it 'includes greeting' do
      expect(mail.body.encoded).to \
        include "Здравствуйте, #{session.account.public_name}"
    end

    it 'includes datetime' do
      expect(mail.body.encoded).to \
        include I18n.localize session.logged_at, format: :long
    end

    it 'includes IP address' do
      expect(mail.body.encoded).to include session.ip_address
    end

    it 'inclused user agent' do
      expect(mail.body.encoded).to include session.user_agent[0...90]
    end
  end
end
