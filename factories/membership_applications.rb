# frozen_string_literal: true

FactoryBot.define do
  factory :membership_application do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { Faker::Name.first_name }
    date_of_birth { Faker::Date.backward }
    occupation { Faker::Company.profession }
    comment { Faker::Lorem.paragraph }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    telegram_username { Faker::Internet.username }
  end
end
