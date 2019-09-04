# frozen_string_literal: true

FactoryBot.define do
  factory :initial_account, class: Account do
    association :contact_list, factory: :empty_contact_list

    public_name { Faker::Name.name }
    biography { Faker::Lorem.paragraph }

    timezone { "#{[nil, :-].sample}#{rand(1..11).to_s.rjust(2, '0')}:00:00" }
  end

  factory :usual_account, parent: :initial_account do
    association :user
  end

  factory :personal_account, parent: :usual_account do
    association :person, factory: :initial_person

    contact_list { person&.contact_list }
  end

  factory :superuser_account, parent: :personal_account do
    superuser { true }
  end
end
