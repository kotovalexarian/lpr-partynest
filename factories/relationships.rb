# frozen_string_literal: true

FactoryBot.define do
  factory :supporter_relationship, class: Relationship do
    association :person, factory: :initial_person
    association :regional_office

    sequence :number
  end

  factory :member_relationship, parent: :supporter_relationship
  factory :excluded_supporter_relationship, parent: :supporter_relationship
  factory :excluded_member_relationship, parent: :member_relationship
end
