# frozen_string_literal: true

FactoryBot.define do
  factory :supporter_relationship, class: Relationship do
    association :person, factory: :initial_person
    association :regional_office

    sequence :number

    sequence :active_since do |n|
      Date.new rand((10 * n)...(11 * n)), rand(1..12), rand(1..28)
    end
  end

  factory :member_relationship, parent: :supporter_relationship
  factory :excluded_supporter_relationship, parent: :supporter_relationship
  factory :excluded_member_relationship, parent: :member_relationship
end
