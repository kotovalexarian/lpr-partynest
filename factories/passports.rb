# frozen_string_literal: true

FactoryBot.define do
  factory :empty_passport, class: Passport do
    association :person, factory: :initial_person

    confirmed { false }

    trait :with_map do
      after :create do |passport, _evaluator|
        create :passport_map, passport: passport
      end
    end

    trait :with_image do
      transient do
        image_filename { image_fixture }
        image_fixture { "passport_image_#{rand(1..4)}.jpg" }

        image_path { Rails.root.join 'fixtures', image_fixture }
      end

      after :build do |passport, evaluator|
        passport.images.attach(
          filename: evaluator.image_filename,
          io: File.open(evaluator.image_path),
        )
      end
    end
  end

  factory :passport_with_map,
          parent: :empty_passport,
          traits: %i[with_map]

  factory :passport_with_image,
          parent: :empty_passport,
          traits: %i[with_image]

  factory :passport_with_map_and_image,
          parent: :empty_passport,
          traits: %i[with_map with_image] do
    trait :with_almost_enough_confirmations do
      after :create do |passport, _evaluator|
        create_list :passport_confirmation,
                    Passport::REQUIRED_CONFIRMATIONS - 1,
                    passport: passport
      end
    end

    trait :with_enough_confirmations do
      after :create do |passport, _evaluator|
        create_list :passport_confirmation,
                    Passport::REQUIRED_CONFIRMATIONS,
                    passport: passport
      end
    end
  end

  factory :passport_with_almost_enough_confirmations,
          parent: :passport_with_map_and_image,
          traits: %i[with_almost_enough_confirmations]

  factory :passport_with_enough_confirmations,
          parent: :passport_with_map_and_image,
          traits: %i[with_enough_confirmations]

  factory :confirmed_passport, parent: :passport_with_enough_confirmations do
    after :create do |passport, _evaluator|
      passport.update! confirmed: true
    end
  end
end
