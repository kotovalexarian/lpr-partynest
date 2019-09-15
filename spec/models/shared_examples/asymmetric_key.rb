# frozen_string_literal: true

RSpec.shared_examples 'asymmetric_key' do
  describe '#account' do
    it { is_expected.to belong_to(:account).optional }

    it { is_expected.not_to validate_presence_of :account }
    it { is_expected.not_to validate_uniqueness_of :account }
  end

  describe '#public_key_pem' do
    it { is_expected.to validate_presence_of :public_key_pem }
    it { is_expected.to validate_uniqueness_of :public_key_pem }
  end

  describe '#public_key_der' do
    it { is_expected.to validate_presence_of :public_key_der }
    it { is_expected.to validate_uniqueness_of :public_key_der }
  end

  describe '#has_password' do
    it { is_expected.not_to validate_presence_of :has_password }
  end

  describe '#bits' do
    it do
      is_expected.to \
        validate_numericality_of(:bits)
        .allow_nil
        .only_integer
        .is_greater_than(0)
    end
  end

  describe '#sha1' do
    it { is_expected.to validate_presence_of :sha1 }
    it { is_expected.to validate_uniqueness_of(:sha1).case_insensitive }
  end

  describe '#sha256' do
    it { is_expected.to validate_presence_of :sha256 }
    it { is_expected.to validate_uniqueness_of(:sha256).case_insensitive }
  end

  describe '#private_key_pem_iv' do
    it { is_expected.not_to validate_presence_of :private_key_pem_iv }
  end

  describe '#private_key_pem_ciphertext' do
    it { is_expected.not_to validate_presence_of :private_key_pem_ciphertext }
  end
end
