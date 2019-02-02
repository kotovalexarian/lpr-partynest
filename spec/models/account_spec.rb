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
      have_many(:account_roles)
      .inverse_of(:account)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:roles)
      .through(:account_roles)
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

  describe '#to_param' do
    specify do
      expect(subject.to_param).to eq subject.username
    end
  end

  describe '#username' do
    def allow_value(*)
      super.for :username
    end

    it { is_expected.to validate_presence_of :username }

    it do
      is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(36)
    end

    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    it { is_expected.not_to allow_value nil }
    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value ' ' * 3 }

    it { is_expected.to allow_value Faker::Internet.username(3..36, %w[_]) }
    it { is_expected.to allow_value 'foo_bar' }
    it { is_expected.to allow_value 'foo123' }

    it do
      is_expected.not_to \
        allow_value Faker::Internet.username(3..36, %w[_]).upcase
    end

    it { is_expected.not_to allow_value Faker::Internet.email }
    it { is_expected.not_to allow_value '_foo' }
    it { is_expected.not_to allow_value 'bar_' }
    it { is_expected.not_to allow_value '1foo' }
  end

  describe '#public_name' do
    def allow_value(*)
      super.for :public_name
    end

    it { is_expected.to allow_value nil }

    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value ' ' }

    it { is_expected.to allow_value Faker::Name.name }
    it { is_expected.to allow_value Faker::Name.first_name }
    it { is_expected.to allow_value 'Foo Bar' }
  end

  describe '#biography' do
    it { is_expected.not_to validate_presence_of :biography }
    it { is_expected.to validate_length_of(:biography).is_at_most(10_000) }
  end

  describe '#has_role?' do
    subject { create :usual_account }

    let(:role) { subject.add_role :superuser }

    let!(:account_role) { role.account_roles.last }

    let(:result) { subject.has_role? :superuser }

    specify do
      expect(result).to eq true
    end

    context 'after role is removed' do
      before do
        subject.remove_role :superuser
      end

      specify do
        expect(result).to eq false
      end
    end
  end

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

  describe '#remove_role' do
    subject { create :usual_account }

    let(:role) { subject.add_role :superuser }

    let!(:account_role) { role.account_roles.last }

    let(:result) { subject.remove_role :superuser }

    specify do
      expect { result }.to change { subject.roles.reload.count }.by(-1)
    end

    specify do
      expect { result }.to change { subject.account_roles.reload.count }.by(-1)
    end

    specify do
      expect { result }.to change { role.accounts.reload.count }.by(-1)
    end

    specify do
      expect { result }.to change { role.account_roles.reload.count }.by(-1)
    end

    specify do
      expect { result }.not_to(change { Role.count })
    end

    specify do
      expect { result }.not_to(change { AccountRole.count })
    end

    specify do
      expect { result }.not_to \
        change { account_role.reload.account }.from(subject)
    end

    specify do
      expect { result }.not_to change { account_role.reload.role }.from(role)
    end

    specify do
      expect { result }.to change { account_role.reload.deleted_at }.from(nil)
      expect(account_role.deleted_at).to be_within(10).of(Time.zone.now)
    end
  end
end
