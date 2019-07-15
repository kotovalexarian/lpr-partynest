# frozen_string_literal: true

FactoryBot.define do
  factory :person_comment do
    association :person,  factory: :initial_person
    association :account, factory: :superuser_account

    text { Faker::Lorem.paragraph 5, false, 5 }
  end
end
