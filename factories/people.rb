# frozen_string_literal: true

FactoryBot.define do
  factory :initial_person, class: Person

  factory :supporter_person, parent: :initial_person do
    supporter_since { rand(1000..10_000).days.ago.to_date }
  end

  factory :member_person, parent: :supporter_person do
    member_since { supporter_since + rand(500) }
  end

  factory :excluded_person, parent: :member_person do
    excluded_since { member_since + rand(500) }
  end
end
