# frozen_string_literal: true

FactoryBot.define do
  factory :federal_subject do
    sequence(:id)     { |n| n + 1000 }
    sequence(:number) { |n| n + 1000 }

    sequence :english_name do |n|
      I18n.with_locale :en do
        "#{Faker::Address.unique.state} #{n}"
      end
    end

    native_name { english_name }

    centre { Faker::Address.city }

    timezone { "#{[nil, :-].sample}#{rand(0..11).to_s.rjust(2, '0')}:00:00" }
  end
end
