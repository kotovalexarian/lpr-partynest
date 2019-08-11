# frozen_string_literal: true

FactoryBot.define do
  factory :some_contact, class: Contact do
    association :contact_list, factory: :empty_contact_list
    association :contact_network

    value { Faker::Internet.username }
  end
end
