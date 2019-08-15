# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AcceptAsSupporter do
  subject do
    described_class.call person: person,
                         regional_office: regional_office,
                         initiator_account: initiator_account
  end

  let!(:person) { create :initial_person }
  let!(:regional_office) { create :regional_office }
  let!(:initiator_account) { create :superuser_account }

  specify { expect(subject).to be_success }

  specify do
    expect { subject }.to change(Relationship, :count).from(0).to(1)
  end

  specify do
    expect { subject }.to change(person.all_relationships, :count).from(0).to(1)
  end

  specify do
    expect { subject }.to change(person, :current_relationship).from(nil)

    expect(person.current_relationship).to have_attributes(
      regional_office: regional_office,
      initiator_account: initiator_account,
      from_date: Time.zone.today,
      status: 'supporter',
      role: nil,
      federal_secretary_flag: nil,
      regional_secretary_flag: nil,
    )
  end

  context 'when person is a supporter' do
    let!(:person) { create :supporter_person }

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end

  context 'when person is a member' do
    let!(:person) { create :member_person }

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end

  context 'when person is excluded' do
    let!(:person) { create :excluded_person }

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end

  context 'when initiator is a federal secretary' do
    let!(:initiator_account) { create :personal_account }

    before do
      create :federal_secretary_relationship, person: initiator_account.person
    end

    specify { expect(subject).to be_success }

    specify do
      expect { subject }.to change(Relationship, :count).by(1)
    end

    specify do
      expect { subject }.to \
        change(person.all_relationships, :count).from(0).to(1)
    end

    specify do
      expect { subject }.to change(person, :current_relationship).from(nil)

      expect(person.current_relationship).to have_attributes(
        regional_office: regional_office,
        initiator_account: initiator_account,
        from_date: Time.zone.today,
        status: 'supporter',
        role: nil,
        federal_secretary_flag: nil,
        regional_secretary_flag: nil,
      )
    end
  end

  context 'when initiator is a regional secretary with the same region' do
    let!(:initiator_account) { create :personal_account }

    before do
      create :regional_secretary_relationship,
             person: initiator_account.person,
             regional_office: regional_office
    end

    specify { expect(subject).to be_success }

    specify do
      expect { subject }.to change(Relationship, :count).by(1)
    end

    specify do
      expect { subject }.to \
        change(person.all_relationships, :count).from(0).to(1)
    end

    specify do
      expect { subject }.to change(person, :current_relationship).from(nil)

      expect(person.current_relationship).to have_attributes(
        regional_office: regional_office,
        initiator_account: initiator_account,
        from_date: Time.zone.today,
        status: 'supporter',
        role: nil,
        federal_secretary_flag: nil,
        regional_secretary_flag: nil,
      )
    end
  end

  context 'when initiator is a regional secretary with different region' do
    let!(:initiator_account) { create :personal_account }

    before do
      create :regional_secretary_relationship, person: initiator_account.person
    end

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end

  context 'when initiator is a federal manager' do
    let!(:initiator_account) { create :personal_account }

    before do
      create :federal_manager_relationship,
             person: initiator_account.person,
             regional_office: regional_office
    end

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end

  context 'when initiator is a federal supervisor' do
    let!(:initiator_account) { create :personal_account }

    before do
      create :federal_supervisor_relationship,
             person: initiator_account.person,
             regional_office: regional_office
    end

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end

  context 'when initiator is a regional manager' do
    let!(:initiator_account) { create :personal_account }

    before do
      create :regional_manager_relationship,
             person: initiator_account.person,
             regional_office: regional_office
    end

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end

  context 'when initiator is a regional supervisor' do
    let!(:initiator_account) { create :personal_account }

    before do
      create :regional_supervisor_relationship,
             person: initiator_account.person,
             regional_office: regional_office
    end

    specify { expect(subject).to be_failure }

    specify do
      expect { subject }.not_to change(Relationship, :count)
    end
  end
end
