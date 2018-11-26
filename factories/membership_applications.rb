# frozen_string_literal: true

FactoryBot.define do
  factory :membership_application do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name  }
    middle_name { Faker::Name.first_name }
  end
end
