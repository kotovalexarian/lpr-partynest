# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EcurveKey do
  subject { create :ecurve_key }

  it_behaves_like 'asymmetric_key'

  describe '#curve' do
    it do
      is_expected.to \
        validate_inclusion_of(:curve).in_array(%w[prime256v1 secp384r1])
    end
  end

  describe '#bits' do
    it { is_expected.to validate_absence_of :bits }
  end
end
