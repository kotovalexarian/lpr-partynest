# frozen_string_literal: true

FactoryBot.define do
  factory :self_signed_x509_certificate, class: X509Certificate do
    pem { File.read Rails.root.join 'fixtures', 'ca.crt' }
    not_before { Faker::Time.backward.utc }
    not_after { Faker::Time.forward.utc }
  end
end
