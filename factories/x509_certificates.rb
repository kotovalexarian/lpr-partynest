# frozen_string_literal: true

FactoryBot.define do
  factory :self_signed_x509_certificate, class: X509Certificate do
    pem { OpenSSL::X509::Certificate.new.to_pem }
  end
end
