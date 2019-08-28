# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /staff/people' do
  let(:current_account) { create :superuser_account }

  let(:person_attributes) { attributes_for :initial_person }

  def make_request
    post '/staff/people', params: { person: person_attributes }
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  for_account_types nil, :guest, :usual do
    specify do
      expect { make_request }.not_to change(Person, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :forbidden
      end
    end
  end

  for_account_types :superuser do
    specify do
      expect { make_request }.to change(Person, :count).by(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to [:staff, Person.last]
      end

      specify do
        expect(Person.last).to have_attributes person_attributes
      end
    end
  end

  context 'when last name is empty' do
    let :person_attributes do
      attributes_for(:initial_person).merge(last_name: '')
    end

    specify do
      expect { make_request }.not_to change(Person, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'when first name is empty' do
    let :person_attributes do
      attributes_for(:initial_person).merge(first_name: '')
    end

    specify do
      expect { make_request }.not_to change(Person, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end
end
