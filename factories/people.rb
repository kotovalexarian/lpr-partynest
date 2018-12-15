# frozen_string_literal: true

FactoryBot.define do
  factory :initial_person, class: Person

  factory :supporter_person, parent: :initial_person do
    supporter_since { rand(10_000).days.ago.to_date }
  end
end
