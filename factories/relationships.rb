# frozen_string_literal: true

FactoryBot.define do
  factory :supporter_relationship, class: Relationship do
    association :person, factory: :initial_person
    association :regional_office

    sequence :from_date do |n|
      Date.new rand((10 * n)...(11 * n)), rand(1..12), rand(1..28)
    end

    status { :supporter }
    role { nil }
  end

  factory :excluded_supporter_relationship, parent: :supporter_relationship do
    status { :excluded }
  end

  factory :excluded_member_relationship, parent: :member_relationship do
    status { :excluded }
  end

  factory :member_relationship, parent: :supporter_relationship do
    status { :member }
  end

  factory :federal_manager_relationship, parent: :member_relationship do
    role { :federal_manager }
  end

  factory :federal_supervisor_relationship, parent: :member_relationship do
    role { :federal_supervisor }
  end

  factory :regional_manager_relationship, parent: :member_relationship do
    role { :regional_manager }
  end

  factory :regional_supervisor_relationship, parent: :member_relationship do
    role { :regional_supervisor }
  end

  factory :federal_secretary_relationship,
          parent: :federal_manager_relationship do
    federal_secretary_flag { :federal_secretary }
  end

  factory :regional_secretary_relationship,
          parent: :regional_manager_relationship do
    regional_secretary_flag { :regional_secretary }
  end
end
