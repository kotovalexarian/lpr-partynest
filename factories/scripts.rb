# frozen_string_literal: true

FactoryBot.define do
  factory :some_script, class: Script do
    codename { Faker::Internet.unique.username 3..36, %w[_] }
    name { Faker::Company.unique.name }

    source_code { "puts 'Hello, World!'\n" }
  end
end
