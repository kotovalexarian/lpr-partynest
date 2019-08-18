# frozen_string_literal: true

FactoryBot.define do
  factory :contact_network, class: ContactNetwork do
    codename { Faker::Internet.username 3..36, %w[_] }
    name { Faker::Company.unique.name }
  end
end
