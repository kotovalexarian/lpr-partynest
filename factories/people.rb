# frozen_string_literal: true

FactoryBot.define do
  factory :initial_person, class: Person do
    transient do
      regional_office { create :regional_office }
    end

    association :contacts_list, factory: :empty_contacts_list

    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sex { Person.sexes.keys.sample }
    date_of_birth { Faker::Date.backward }
    place_of_birth { Faker::Address.city }
  end

  factory :supporter_person, parent: :initial_person do
    after :create do |person, evaluator|
      create :supporter_relationship,
             person: person,
             regional_office: evaluator.regional_office
    end
  end

  factory :member_person, parent: :supporter_person do
    after :create do |person, evaluator|
      create :member_relationship,
             person: person,
             regional_office: evaluator.regional_office
    end
  end

  factory :excluded_person, parent: :member_person do
    after :create do |person, evaluator|
      create :excluded_relationship,
             person: person,
             regional_office: evaluator.regional_office
    end
  end
end
