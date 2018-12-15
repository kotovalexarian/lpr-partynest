# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :person }

  it { is_expected.to belong_to(:regional_office) }

  it { is_expected.to have_one(:account).dependent(:restrict_with_exception) }

  it do
    is_expected.to \
      have_one(:own_membership_app)
      .class_name('MembershipApp')
      .inverse_of(:person)
      .through(:account)
      .source(:own_membership_app)
  end

  it { is_expected.not_to validate_presence_of :regional_office }

  pending '#related_to_party?'
  pending '#party_supporter?'
  pending '#party_member?'
  pending '#excluded_from_party?'

  describe '#supporter_since' do
    def allow_value(*)
      super.for :supporter_since
    end

    it { is_expected.not_to validate_presence_of :supporter_since }

    it { is_expected.to allow_value Time.zone.today }
    it { is_expected.to allow_value Time.zone.yesterday }
    it { is_expected.to allow_value rand(10_000).days.ago.to_date }

    it { is_expected.not_to allow_value Time.zone.tomorrow }
    it { is_expected.not_to allow_value 1.day.from_now.to_date }
    it { is_expected.not_to allow_value rand(10_000).days.from_now.to_date }
  end
end
