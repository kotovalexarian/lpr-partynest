# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /membership_applications' do
  let :membership_application_attributes do
    attributes_for :membership_application
  end

  def make_request
    post '/membership_applications',
         params: { membership_application: membership_application_attributes }
  end

  specify do
    expect { make_request }.to \
      change(MembershipApplication, :count).from(0).to(1)
  end

  context 'after request' do
    before do
      make_request
    end

    specify do
      expect(MembershipApplication.last).to \
        have_attributes membership_application_attributes
    end
  end
end
