# frozen_string_literal: true

FactoryBot.define do
  factory :empty_resident_registration, class: ResidentRegistration do
    association :person, factory: :initial_person
  end
end
