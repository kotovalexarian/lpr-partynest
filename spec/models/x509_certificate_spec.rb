# frozen_string_literal: true

require 'rails_helper'

RSpec.describe X509Certificate do
  subject { create :self_signed_x509_certificate }

  describe '#x509_certificate_request' do
    it { is_expected.not_to validate_presence_of :x509_certificate_request }
  end

  describe '#pem' do
    it { is_expected.to validate_presence_of :pem }
  end
end
