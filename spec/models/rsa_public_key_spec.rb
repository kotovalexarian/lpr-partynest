# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSAPublicKey do
  subject { create :rsa_public_key }

  describe '#public_key_pem' do
    it { is_expected.to validate_presence_of :public_key_pem }
  end

  describe '#bits' do
    it { is_expected.to validate_inclusion_of(:bits).in_array([2048, 4096]) }
  end

  describe '#private_key_pem_iv' do
    it { is_expected.not_to validate_presence_of :private_key_pem_iv }
  end

  describe '#private_key_pem_ciphertext' do
    it { is_expected.not_to validate_presence_of :private_key_pem_ciphertext }
  end
end
