# frozen_string_literal: true

FactoryBot.define do
  factory :passport do
    transient do
      image_filename { image_fixture }
      image_fixture { "passport_image_#{rand(1..4)}.jpg" }

      image_path { Rails.root.join 'fixtures', image_fixture }
    end

    surname { Faker::Name.last_name }
    given_name { Faker::Name.first_name }
    patronymic { Faker::Name.first_name }
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

    after :build do |passport, evaluator|
      passport.image.attach(
        filename: evaluator.image_filename,
        io:       File.open(evaluator.image_path),
      )
    end
  end
end
