# frozen_string_literal: true

FactoryBot.define do
  factory :passport_without_image, class: Passport do
    confirmed { false }

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
  end

  factory :passport_with_image, parent: :passport_without_image do
    transient do
      image_filename { image_fixture }
      image_fixture { "passport_image_#{rand(1..4)}.jpg" }

      image_path { Rails.root.join 'fixtures', image_fixture }
    end

    after :build do |passport, evaluator|
      passport.images.attach(
        filename: evaluator.image_filename,
        io:       File.open(evaluator.image_path),
      )
    end
  end

  factory :passport_with_almost_enough_confirmations,
          parent: :passport_with_image do
    after :create do |passport, _evaluator|
      create_list :passport_confirmation,
                  Passport::REQUIRED_CONFIRMATIONS - 1,
                  passport: passport
    end
  end

  factory :passport_with_enough_confirmations,
          parent: :passport_with_image do
    after :create do |passport, _evaluator|
      create_list :passport_confirmation,
                  Passport::REQUIRED_CONFIRMATIONS,
                  passport: passport
    end
  end

  factory :confirmed_passport, parent: :passport_with_enough_confirmations do
    after :create do |passport, _evaluator|
      passport.update! confirmed: true
    end
  end
end
