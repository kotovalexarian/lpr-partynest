# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  subject { create :personal_account }

  pending '#can_access_sidekiq_web_interface?'

  describe '#to_param' do
    specify do
      expect(subject.to_param).to eq subject.nickname
    end
  end

  describe '#user' do
    it do
      is_expected.to \
        have_one(:user)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#sessions' do
    it do
      is_expected.to \
        have_many(:sessions)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#person' do
    it { is_expected.to belong_to(:person).optional }

    it { is_expected.not_to validate_presence_of :person }
  end

  describe '#contact_list' do
    def allow_value(*)
      super.for :contact_list
    end

    xit { is_expected.to belong_to(:contact_list).required }

    context 'for usual account' do
      subject { create :usual_account }

      it { is_expected.to allow_value create :empty_contact_list }
    end

    context 'for personal account' do
      subject { create :personal_account }

      it { is_expected.not_to allow_value create :empty_contact_list }

      it { is_expected.to allow_value subject.person.contact_list }

      specify do
        expect(subject.contact_list).to eq subject.person.contact_list
      end

      context 'when it was changed' do
        before do
          subject.contact_list = ContactList.new
        end

        specify do
          expect { subject.save validate: false }.to raise_error(
            ActiveRecord::StatementInvalid,
            /\APG::RaiseException:\sERROR:\s\s
              column\s"contact_list_id"\sdoes\snot\smatch\srelated\sperson$/x,
          )
        end
      end
    end
  end

  describe '#timezone' do
    def allow_value(*)
      super.for :timezone
    end

    it { is_expected.to validate_presence_of :timezone }

    it { is_expected.to allow_value '00:00:00' }
    it { is_expected.to allow_value '01:00:00' }
    it { is_expected.to allow_value '-01:00:00' }
    it { is_expected.to allow_value '05:00:00' }
    it { is_expected.to allow_value '-09:00:00' }
    it { is_expected.to allow_value '12:00:00' }
    it { is_expected.to allow_value '-12:00:00' }
    it { is_expected.to allow_value '03:30:00' }
    it { is_expected.to allow_value '-11:30:00' }
    it { is_expected.to allow_value '10:45:00' }
    it { is_expected.to allow_value '-06:15:00' }

    it { is_expected.not_to allow_value '+01:00:00' }
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

    it { is_expected.to validate_length_of(:public_name).is_at_most(255) }

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

    it { is_expected.to validate_length_of(:biography).is_at_most(10_000) }

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

  describe '#restricted?' do
    let(:result) { subject.restricted? }

    context 'for usual account' do
      subject { create :usual_account }
      specify { expect(result).to equal true }
    end

    context 'for personal account' do
      subject { create :personal_account }
      specify { expect(result).to equal true }
    end

    context 'for superuser account' do
      subject { create :superuser_account }
      specify { expect(result).to equal false }
    end
  end

  describe '#can_initiate_relationship?' do
    let(:result) { subject.can_initiate_relationship? regional_office }

    let(:regional_office) { create :regional_office }

    context 'for usual account' do
      subject { create :usual_account }
      specify { expect(result).to equal false }
    end

    context 'for personal account' do
      subject { create :personal_account }
      specify { expect(result).to equal false }
    end

    context 'for superuser account' do
      subject { create :superuser_account }
      specify { expect(result).to equal true }
    end

    context 'for federal secretary account' do
      subject { create :personal_account }
      before { create :federal_secretary_relationship, person: subject.person }
      specify { expect(result).to equal true }
    end

    context 'for regional secretary account with same region' do
      subject { create :personal_account }
      before do
        create :regional_secretary_relationship,
               person: subject.person, regional_office: regional_office
      end
      specify { expect(result).to equal true }
    end

    context 'for regional secretary account with different region' do
      subject { create :personal_account }
      before do
        create :regional_secretary_relationship, person: subject.person
      end
      specify { expect(result).to equal false }
    end

    context 'for federal manager account' do
      subject { create :personal_account }
      before do
        create :federal_manager_relationship,
               person: subject.person, regional_office: regional_office
      end
      specify { expect(result).to equal false }
    end

    context 'for federal supervisor account' do
      subject { create :personal_account }
      before do
        create :federal_supervisor_relationship,
               person: subject.person, regional_office: regional_office
      end
      specify { expect(result).to equal false }
    end

    context 'for regional manager account' do
      subject { create :personal_account }
      before do
        create :regional_manager_relationship,
               person: subject.person, regional_office: regional_office
      end
      specify { expect(result).to equal false }
    end

    context 'for regional supervisor account' do
      subject { create :personal_account }
      before do
        create :regional_supervisor_relationship,
               person: subject.person, regional_office: regional_office
      end
      specify { expect(result).to equal false }
    end
  end
end
