# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :initial_person }

  it_behaves_like 'nameable'

  describe '#account' do
    it { is_expected.to have_one(:account).dependent(:restrict_with_exception) }
  end

  describe '#account_connection_token' do
    def allow_value(*)
      super.for :account_connection_token
    end

    it { is_expected.not_to validate_presence_of :account_connection_token }

    it do
      is_expected.to \
        validate_length_of(:account_connection_token).is_equal_to(32)
    end

    it { is_expected.to allow_value nil }
    it { is_expected.to allow_value SecureRandom.alphanumeric(32) }
    it { is_expected.to allow_value '_' * 32 }

    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value 'q' }
    it { is_expected.not_to allow_value SecureRandom.alphanumeric(31) }
    it { is_expected.not_to allow_value SecureRandom.alphanumeric(33) }

    %w[
      ~ ` ! @ # $ % ^ & * ( ) - = + [ { ] } \ | ; : ' " , < . > / ?
    ].each do |char|
      it { is_expected.not_to allow_value char * 32 }
    end
  end

  describe '#contact_list' do
    xit { is_expected.to belong_to(:contact_list).required }

    context 'when it was changed' do
      before do
        subject.contact_list = ContactList.new
      end

      specify do
        expect { subject.save }.to raise_error(
          ActiveRecord::StatementInvalid,
          /\APG::RaiseException:\s
            ERROR:\s\scan\snot\schange\scolumn\s"contact_list_id"$/x,
        )
      end
    end
  end

  describe '#all_relationships' do
    let(:parent_relationship) { create :included_relationship, person: subject }

    let! :relationship_2 do
      create :supporter_relationship,
             person: subject,
             parent_rel: parent_relationship,
             from_date: 4.days.ago
    end

    let! :relationship_3 do
      create :supporter_relationship,
             person: subject,
             parent_rel: parent_relationship,
             from_date: 2.days.ago
    end

    let! :relationship_1 do
      create :supporter_relationship,
             person: subject,
             parent_rel: parent_relationship,
             from_date: 6.days.ago
    end

    it do
      is_expected.to \
        have_many(:all_relationships)
        .class_name('Relationship')
        .inverse_of(:person)
        .dependent(:restrict_with_exception)
        .order(from_date: :asc)
    end

    specify do
      expect(subject.all_relationships).to eq [
        parent_relationship,
        relationship_1,
        relationship_2,
        relationship_3,
      ]
    end
  end

  describe '#current_relationship' do
    it do
      is_expected.to \
        have_one(:current_relationship)
        .class_name('Relationship')
        .inverse_of(:person)
        .dependent(:restrict_with_exception)
        .order(from_date: :desc)
    end

    let! :relationship_2 do
      create :supporter_relationship,
             person: subject,
             from_date: 4.days.ago
    end

    let! :relationship_3 do
      create :supporter_relationship,
             person: subject,
             from_date: 2.days.ago
    end

    let! :relationship_1 do
      create :supporter_relationship,
             person: subject,
             from_date: 6.days.ago
    end

    specify do
      expect(subject.current_relationship).to eq relationship_3
    end
  end

  describe '#person_comments' do
    it do
      is_expected.to \
        have_many(:person_comments)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#passports' do
    it do
      is_expected.to \
        have_many(:passports)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#full_name' do
    specify do
      expect(subject.full_name).to be_instance_of String
    end

    specify do
      expect(subject.full_name).to be_frozen
    end

    specify do
      expect(subject.full_name).to eq(
        [
          subject.last_name,
          subject.first_name,
          subject.middle_name,
        ].compact.join(' '),
      )
    end
  end

  describe '#generate_account_connection_token' do
    specify do
      expect { subject.generate_account_connection_token }.to \
        change(subject, :account_connection_token)
        .from(nil)
    end

    context 'when token already exists' do
      before do
        subject.generate_account_connection_token
      end

      specify do
        expect { subject.generate_account_connection_token }.to \
          change(subject, :account_connection_token)
          .from(subject.account_connection_token)
      end
    end
  end
end
