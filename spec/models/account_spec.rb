# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  subject { create :personal_account }

  it { is_expected.to belong_to(:person).optional }

  it do
    is_expected.to \
      have_one(:user)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:account_telegram_contacts)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_one(:own_membership_app)
      .class_name('MembershipApp')
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:passport_confirmations)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.not_to validate_presence_of :person }
  it { is_expected.not_to validate_presence_of :user }

  pending '.guests'
  pending '#guest?'
  pending '#can_access_sidekiq_web_interface?'

  describe '#add_role' do
    context 'to guest account' do
      subject { create :guest_account }

      let(:result) { subject.add_role :superuser }

      specify do
        expect { result }.to \
          raise_error RuntimeError, 'can not add role to guest account'
      end

      specify do
        expect { result rescue nil }.not_to(
          change { subject.roles.reload.count },
        )
      end
    end
  end
end
