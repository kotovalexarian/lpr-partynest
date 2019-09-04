# frozen_string_literal: true

FactoryBot.define do
  factory :some_contact, class: Contact do
    association :contact_list, factory: :empty_contact_list
    association :contact_network

    value { Faker::Internet.username }
  end

  factory :email_contact, parent: :some_contact do
    association :contact_network, factory: :email_contact_network

    value { Faker::Internet.email }
  end

  factory :phone_contact, parent: :some_contact do
    association :contact_network, factory: :phone_contact_network

    value { Faker::PhoneNumber.cell_phone_with_country_code }
  end
end
