# frozen_string_literal: true

FactoryBot.define do
  factory :empty_passport, class: Passport do
    association :person, factory: :initial_person

    trait :with_map do
      after :create do |passport, _evaluator|
        create :passport_map, passport: passport
      end
    end
  end

  factory :passport_with_map,
          parent: :empty_passport,
          traits: %i[with_map]
end
