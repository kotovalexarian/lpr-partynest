# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrgUnit do
  subject { create :some_children_org_unit }

  describe '#kind' do
    it do
      is_expected.to \
        belong_to(:kind)
        .class_name('OrgUnitKind')
        .inverse_of(:instances)
        .required
    end

    it { is_expected.to validate_presence_of(:kind).with_message(:required) }
  end

  describe '#parent' do
    it do
      is_expected.to \
        belong_to(:parent)
        .class_name('OrgUnit')
        .inverse_of(:children)
    end

    context 'when organizational unit type does not require parent' do
      subject { create :some_root_org_unit }

      it do
        is_expected.not_to validate_presence_of(:parent).with_message(:required)
      end
    end

    context 'when organizational unit type does not require parent' do
      subject { create :some_children_org_unit }

      it do
        is_expected.to validate_presence_of(:parent).with_message(:required)
      end
    end
  end
end
