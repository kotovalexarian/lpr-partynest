# frozen_string_literal: true

FactoryBot.define do
  factory :empty_passport, class: Passport do
    association :person, factory: :initial_person

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
          traits: %i[with_map with_image]
end
