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
      expect(subject.to_param).to eq subject.nickname
    end
  end

  describe '#nickname' do
    def allow_value(*)
      super.for :nickname
    end

    it { is_expected.to validate_presence_of :nickname }

    it do
      is_expected.to validate_length_of(:nickname).is_at_least(3).is_at_most(36)
    end

    it { is_expected.to validate_uniqueness_of(:nickname).case_insensitive }

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
    it { is_expected.to allow_value '' }
    it { is_expected.to allow_value ' ' }

    it { is_expected.to allow_value Faker::Name.name }
    it { is_expected.to allow_value Faker::Name.first_name }
    it { is_expected.to allow_value 'Foo Bar' }

    it do
      is_expected.to \
        validate_length_of(:public_name).is_at_least(3).is_at_most(255)
    end

    context 'when it was set to blank value' do
      subject { create :personal_account, public_name: ' ' * rand(100) }

      specify do
        expect(subject.public_name).to eq nil
      end
    end

    context 'when it was set to value with leading and trailing spaces' do
      subject { create :personal_account, public_name: public_name }

      let :public_name do
        "#{' ' * rand(4)}#{Faker::Name.name}#{' ' * rand(4)}"
      end

      specify do
        expect(subject.public_name).to eq public_name.strip
      end
    end
  end

  describe '#biography' do
    def allow_value(*)
      super.for :biography
    end

    it { is_expected.to allow_value nil }
    it { is_expected.to allow_value '' }
    it { is_expected.to allow_value ' ' }

    it { is_expected.to allow_value Faker::Lorem.sentence }

    it do
      is_expected.to \
        validate_length_of(:biography).is_at_least(3).is_at_most(10_000)
    end

    context 'when it was set to blank value' do
      subject { create :personal_account, biography: ' ' * rand(100) }

      specify do
        expect(subject.biography).to eq nil
      end
    end

    context 'when it was set to value with leading and trailing spaces' do
      subject { create :personal_account, biography: biography }

      let :biography do
        "#{' ' * rand(4)}#{Faker::Lorem.sentence}#{' ' * rand(4)}"
      end

      specify do
        expect(subject.biography).to eq biography.strip
      end
    end
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

    context 'before role expires' do
      before do
        account_role.update! expires_at: 2.seconds.from_now
      end

      specify do
        expect(result).to eq true
      end
    end

    context 'before role expires' do
      before do
        account_role.update! expires_at: Faker::Time.forward
      end

      specify do
        expect(result).to eq true
      end
    end

    context 'after role expires' do
      before do
        account_role.update! expires_at: 1.second.ago
      end

      specify do
        expect(result).to eq false
      end
    end

    context 'after role expires' do
      before do
        account_role.update! expires_at: Faker::Time.backward
      end

      specify do
        expect(result).to eq false
      end
    end
  end

  describe '#add_role' do
    subject { create :usual_account }

    let(:result) { subject.add_role :superuser }

    let(:account_role) { result; AccountRole.last }

    specify do
      expect { result }.to change { subject.roles.reload.count }.by(1)
    end

    specify do
      expect { result }.to change { subject.account_roles.reload.count }.by(1)
    end

    specify do
      expect { result }.to change { Role.count }.by(1)
    end

    specify do
      expect { result }.to change { AccountRole.count }.by(1)
    end

    specify do
      expect(account_role.account).to eq subject
    end

    specify do
      expect(account_role.role).to eq result
    end

    context 'to guest account' do
      subject { create :guest_account }

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
