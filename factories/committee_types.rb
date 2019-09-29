# frozen_string_literal: true

FactoryBot.define do
  factory :some_committee_type, class: CommitteeType do
    codename { Faker::Internet.unique.username 3..36, %w[_] }
    name { Faker::Company.unique.name }

    regional { [false, true].sample }
  end
end
