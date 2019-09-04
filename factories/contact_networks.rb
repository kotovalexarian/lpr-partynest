# frozen_string_literal: true

FactoryBot.define do
  factory :contact_network do
    codename { Faker::Internet.unique.username 3..36, %w[_] }
    name { Faker::Company.unique.name }
  end

  factory :email_contact_network, class: ContactNetwork do
    initialize_with do
      ContactNetwork.find_or_initialize_by codename: 'email'
    end

    codename { 'email' }
    name { 'Email' }
  end

  factory :phone_contact_network, class: ContactNetwork do
    initialize_with do
      ContactNetwork.find_or_initialize_by codename: 'phone'
    end

    codename { 'phone' }
    name { 'Phone' }
  end
end
