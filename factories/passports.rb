# frozen_string_literal: true

FactoryBot.define do
  factory :empty_passport, class: Passport do
    association :person, factory: :initial_person

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
  end
end
