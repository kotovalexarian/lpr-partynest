# frozen_string_literal: true

FactoryBot.define do
  factory :initial_person, class: Person do
    association :contacts_list, factory: :empty_contacts_list

    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sex { Person.sexes.keys.sample }
    date_of_birth { Faker::Date.backward }
    place_of_birth { Faker::Address.city }
  end

  factory :supporter_person, parent: :initial_person
  factory :member_person, parent: :supporter_person
  factory :excluded_person, parent: :member_person
end
