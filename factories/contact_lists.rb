# frozen_string_literal: true

FactoryBot.define do
  factory :empty_contact_list, class: ContactList

  factory :some_contact_list, parent: :empty_contact_list do
    transient do
      contacts_count { rand 1..5 }
    end

    after :create do |contact_list, evaluator|
      create_list :some_contact,
                  evaluator.contacts_count,
                  contact_list: contact_list
    end
  end
end
