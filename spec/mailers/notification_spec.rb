# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer do
  describe '#signed_in' do
    let(:mail) { NotificationMailer.signed_in email, session }

    let(:email) { Faker::Internet.email }
    let(:session) { create :some_session }

    it 'renders the headers' do
      expect(mail.subject).to eq '[LPR Alert]: Произведён вход в ваш аккаунт'
      expect(mail.from).to eq ['no-reply@libertarian-party.com']
      expect(mail.to).to eq [email]
    end

    it 'includes greeting' do
      expect(mail.body.encoded).to \
        match "Здравствуйте, #{session.account.public_name}"
    end

    it 'includes datetime' do
      expect(mail.body.encoded).to \
        match I18n.localize session.logged_at, format: :long
    end

    it 'includes IP address' do
      expect(mail.body.encoded).to match session.ip_address
    end
  end
end
