# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipApp do
  subject { create :membership_app }

  it { is_expected.to belong_to(:account).inverse_of(:own_membership_app) }
  it { is_expected.to belong_to(:country_state).optional }

  it { is_expected.to have_one(:regional_office).through(:country_state) }

  it do
    is_expected.to \
      have_one(:person)
      .through(:account)
      .inverse_of(:own_membership_app)
  end

  it { is_expected.to validate_presence_of(:account).with_message(:required) }
  it { is_expected.not_to validate_presence_of :country_state }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.not_to validate_presence_of :middle_name }
  it { is_expected.to validate_presence_of :date_of_birth }
  it { is_expected.not_to validate_presence_of :occupation }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :phone_number }
  it { is_expected.not_to validate_presence_of :telegram_username }
  it { is_expected.not_to validate_presence_of :organization_membership }
  it { is_expected.not_to validate_presence_of :comment }

  it { is_expected.to validate_uniqueness_of :account }

  describe '#email' do
    def allow_value(*)
      super.for :email
    end

    it { is_expected.to allow_value Faker::Internet.email }
    it { is_expected.not_to allow_value Faker::Internet.username }

    context 'when it has extra spaces' do
      subject { create :membership_app, email: " #{email} " }

      let(:email) { Faker::Internet.email }

      specify do
        expect(subject.email).to eq email
      end
    end
  end

  describe '#middle_name' do
    context 'when it is empty' do
      subject { create :membership_app, middle_name: '' }

      specify do
        expect(subject.middle_name).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :membership_app, middle_name: '   ' }

      specify do
        expect(subject.middle_name).to eq nil
      end
    end
  end

  describe '#occupation' do
    context 'when it is empty' do
      subject { create :membership_app, occupation: '' }

      specify do
        expect(subject.occupation).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :membership_app, occupation: '   ' }

      specify do
        expect(subject.occupation).to eq nil
      end
    end
  end

  describe '#telegram_username' do
    context 'when it is empty' do
      subject { create :membership_app, telegram_username: '' }

      specify do
        expect(subject.telegram_username).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :membership_app, telegram_username: '   ' }

      specify do
        expect(subject.telegram_username).to eq nil
      end
    end
  end

  describe '#organization_membership' do
    context 'when it is empty' do
      subject { create :membership_app, organization_membership: '' }

      specify do
        expect(subject.organization_membership).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :membership_app, organization_membership: '   ' }

      specify do
        expect(subject.organization_membership).to eq nil
      end
    end
  end

  describe '#comment' do
    context 'when it is empty' do
      subject { create :membership_app, comment: '' }

      specify do
        expect(subject.comment).to eq nil
      end
    end

    context 'when it is blank' do
      subject { create :membership_app, comment: '   ' }

      specify do
        expect(subject.comment).to eq nil
      end
    end
  end
end
