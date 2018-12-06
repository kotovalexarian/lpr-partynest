# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /membership_applications' do
  let :membership_application_plain_attributes do
    attributes_for :membership_application
  end

  let :membership_application_all_attributes do
    membership_application_plain_attributes.merge(
      country_state_id: country_state&.id,
    )
  end

  let(:country_state) { create :country_state }

  def make_request
    post '/membership_applications', params: {
      membership_application: membership_application_all_attributes,
    }
  end

  specify do
    expect { make_request }.to \
      change(MembershipApplication, :count).from(0).to(1)
  end

  specify do
    expect { make_request }.to \
      change(Account, :count).from(0).to(1)
  end

  specify do
    expect { make_request }.to \
      change(ActionMailer::Base.deliveries, :count).from(0).to(1)
  end

  context 'after request' do
    before { make_request }

    specify do
      expect(response).to redirect_to MembershipApplication.last
    end

    specify do
      expect(MembershipApplication.last).to \
        have_attributes membership_application_plain_attributes
    end

    specify do
      expect(MembershipApplication.last).to have_attributes(
        country_state: country_state,
      )
    end

    specify do
      expect(ActionMailer::Base.deliveries.last).to have_attributes(
        from:    [Rails.application.config.noreply_email_address],
        to:      [MembershipApplication.last.email],
        subject: I18n.t('membership_application_mailer.tracking.subject'),
      )
    end
  end

  context 'when country state is not specified' do
    let(:country_state) { nil }

    specify do
      expect { make_request }.to \
        change(MembershipApplication, :count).from(0).to(1)
    end

    specify do
      expect { make_request }.to \
        change(Account, :count).from(0).to(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to MembershipApplication.last
      end

      specify do
        expect(MembershipApplication.last).to \
          have_attributes membership_application_plain_attributes
      end

      specify do
        expect(MembershipApplication.last).to have_attributes(
          country_state: nil,
        )
      end
    end
  end
end
