# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /staff/people/:person_id/comments' do
  let(:current_account) { create :superuser_account }

  let!(:person) { create :initial_person }

  let(:person_comment_attributes) { attributes_for :person_comment }

  def make_request
    post "/staff/people/#{person.id}/comments",
         params: { person_comment: person_comment_attributes }
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  for_account_types nil, :guest, :usual do
    specify do
      expect { make_request }.not_to change(PersonComment, :count)
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
      expect { make_request }.to change(PersonComment, :count).from(0).to(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to [:staff, person, :person_comments]
      end

      specify do
        expect(PersonComment.last).to have_attributes person_comment_attributes
      end
    end
  end
end
