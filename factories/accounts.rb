# frozen_string_literal: true

FactoryBot.define do
  factory :initial_account, class: Account do
    public_name { Faker::Name.name }
    biography { Faker::Lorem.paragraph }

    timezone { "#{[nil, :-].sample}#{rand(0..11).to_s.rjust(2, '0')}:00:00" }
  end

  factory :usual_account, parent: :initial_account do
    association :user
  end

  factory :personal_account, parent: :usual_account do
    association :person, factory: :initial_person
  end

  factory :superuser_account, parent: :personal_account do
    superuser { true }
  end
end
