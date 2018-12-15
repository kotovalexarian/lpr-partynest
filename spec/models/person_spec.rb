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
end
