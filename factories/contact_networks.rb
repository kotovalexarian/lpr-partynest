# frozen_string_literal: true

FactoryBot.define do
  factory :contact_network, class: ContactNetwork do
    nickname { Faker::Internet.username 3..36, %w[_] }
    public_name { Faker::Company.name }
  end
end
