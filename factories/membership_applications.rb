# frozen_string_literal: true

FactoryBot.define do
  factory :membership_application do
    country_state

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { Faker::Name.first_name }
    date_of_birth { Faker::Date.backward }
    occupation { Faker::Company.profession }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    telegram_username { Faker::Internet.username }
    organization_membership { Faker::Lorem.paragraph }
    comment { Faker::Lorem.paragraph }
  end
end
