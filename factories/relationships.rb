# frozen_string_literal: true

FactoryBot.define do
  factory :supporter_relationship, class: Relationship do
    association :person, factory: :initial_person
    association :regional_office

    sequence :from_date do |n|
      Date.new rand((10 * n)...(11 * n)), rand(1..12), rand(1..28)
    end

    status { :supporter }
  end

  factory :member_relationship, parent: :supporter_relationship do
    status { :member }
  end

  factory :excluded_supporter_relationship, parent: :supporter_relationship do
    status { :excluded }
  end

  factory :excluded_member_relationship, parent: :member_relationship do
    status { :excluded }
  end
end
