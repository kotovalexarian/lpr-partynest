# frozen_string_literal: true

FactoryBot.define do
  factory :empty_passport, class: Passport

  factory :passport_without_image, parent: :empty_passport do
    confirmed { false }
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
