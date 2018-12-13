# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /join' do
  let :membership_app_plain_attributes do
    attributes_for :membership_app
  end

  let :membership_app_all_attributes do
    membership_app_plain_attributes.merge(
      country_state_id: country_state&.id,
    )
  end

  let(:country_state) { create :country_state }

  def make_request
    post '/join', params: {
      membership_app: membership_app_all_attributes,
    }
  end

  specify do
    expect { make_request }.to \
      change(MembershipApp, :count).from(0).to(1)
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
      membership_app = MembershipApp.last

      expect(response).to redirect_to membership_app_url(
        membership_app,
        guest_token: membership_app.account.guest_token,
      )
    end

    specify do
      expect(MembershipApp.last).to \
        have_attributes membership_app_plain_attributes
    end

    specify do
      expect(MembershipApp.last).to have_attributes(
        country_state: country_state,
      )
    end

    specify do
      expect(ActionMailer::Base.deliveries.last).to have_attributes(
        from:    [Rails.application.config.noreply_email_address],
        to:      [MembershipApp.last.email],
        subject: I18n.t('membership_app_mailer.tracking.subject'),
      )
    end
  end

  context 'when country state is not specified' do
    let(:country_state) { nil }

    specify do
      expect { make_request }.to \
        change(MembershipApp, :count).from(0).to(1)
    end

    specify do
      expect { make_request }.to \
        change(Account, :count).from(0).to(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        membership_app = MembershipApp.last

        expect(response).to redirect_to membership_app_url(
          membership_app,
          guest_token: membership_app.account.guest_token,
        )
      end

      specify do
        expect(MembershipApp.last).to \
          have_attributes membership_app_plain_attributes
      end

      specify do
        expect(MembershipApp.last).to have_attributes(
          country_state: nil,
        )
      end
    end
  end
end
