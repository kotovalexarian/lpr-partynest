# frozen_string_literal: true

FactoryBot.define do
  factory :supporter_relationship, class: Relationship do
    association :status, factory: :some_relation_status
    association :person, factory: :initial_person

    sequence :from_date do |n|
      Date.new rand((10 * n)...(11 * n)), rand(1..12), rand(1..28)
    end
  end

  factory :excluded_relationship, parent: :supporter_relationship

  factory :member_relationship, parent: :supporter_relationship

  factory :federal_manager_relationship, parent: :member_relationship

  factory :federal_supervisor_relationship, parent: :member_relationship

  factory :regional_manager_relationship, parent: :member_relationship

  factory :regional_supervisor_relationship, parent: :member_relationship

  factory :federal_secretary_relationship,
          parent: :federal_manager_relationship

  factory :regional_secretary_relationship,
          parent: :regional_manager_relationship
end
