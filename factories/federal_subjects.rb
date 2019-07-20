# frozen_string_literal: true

FactoryBot.define do
  factory :federal_subject do
    initialize_with do
      FederalSubject.find_or_initialize_by english_name: english_name
    end

    english_name do
      I18n.with_locale :en do
        Faker::Address.unique.state
      end
    end

    native_name { english_name }

    sequence :number

    timezone { "#{[nil, :-].sample}#{rand(0..11).to_s.rjust(2, '0')}:00:00" }
  end
end
