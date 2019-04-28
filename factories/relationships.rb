# frozen_string_literal: true

FactoryBot.define do
  factory :supporter_relationship, class: Relationship do
    association :person, factory: :initial_person
    association :regional_office

    sequence :number

    supporter_since { rand(1000..10_000).days.ago.to_date }
  end

  factory :member_relationship, parent: :supporter_relationship do
    member_since { supporter_since + rand(500) }
  end

  factory :excluded_supporter_relationship, parent: :supporter_relationship do
    excluded_since { supporter_since + rand(500) }
  end

  factory :excluded_member_relationship, parent: :member_relationship do
    excluded_since { member_since + rand(500) }
  end
end
