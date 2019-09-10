# frozen_string_literal: true

FactoryBot.define do
  factory :x509_certificate_request do
    association :rsa_public_key

    distinguished_name { "CN=#{Faker::Internet.domain_name}" }
  end
end
