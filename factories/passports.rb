# frozen_string_literal: true

FactoryBot.define do
  factory :empty_passport, class: Passport do
    association :person,          factory: :initial_person
    association :federal_subject, factory: :federal_subject

    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sex { Passport.sexes.keys.sample }
    date_of_birth { Faker::Date.backward }
    place_of_birth { Faker::Address.city }
    series { rand 0..9999 }
    number { rand 0..999_999 }
    issued_by { Faker::Lorem.sentence }
    unit_code do
      "#{rand(0..999).to_s.rjust(3, '0')}-#{rand(0..999).to_s.rjust(3, '0')}"
    end
    date_of_issue { Faker::Date.backward }

    zip_code { Faker::Address.zip_code }

    town_type       { 'город' }
    town_name       { Faker::Address.city }
    settlement_type { 'посёлок' }
    settlement_name { Faker::Address.city }
    district_type   { 'район' }
    district_name   { Faker::Address.community }
    street_type     { 'улица' }
    street_name     { Faker::Address.street_name }
    residence_type  { 'дом' }
    residence_name  { Faker::Address.building_number }
    building_type   { 'строение' }
    building_name   { rand(1..3).to_s }
    apartment_type  { 'квартира' }
    apartment_name  { rand(1..150).to_s }
  end
end
