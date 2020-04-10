# frozen_string_literal: true

FactoryBot.define do
  factory :contact_network do
    codename { Faker::Internet.unique.username 3..36, %w[_] }
    name { Faker::Company.unique.name }
    link { nil }
  end

  factory :email_contact_network, class: ContactNetwork do
    initialize_with do
      ContactNetwork.find_or_initialize_by codename: 'email'
    end

    codename { 'email' }
    name { 'Email' }
    link { 'mailto:$$' }
  end

  factory :phone_contact_network, class: ContactNetwork do
    initialize_with do
      ContactNetwork.find_or_initialize_by codename: 'phone'
    end

    codename { 'phone' }
    name { 'Phone' }
    link { nil }
  end
end
