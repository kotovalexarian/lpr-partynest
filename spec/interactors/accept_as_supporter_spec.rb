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
end
