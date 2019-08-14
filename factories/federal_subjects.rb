# frozen_string_literal: true

FactoryBot.define do
  factory :federal_subject do
    number { rand 1..2**31 - 1 }

    english_name do
      I18n.with_locale :en do
        "#{Faker::Address.state} #{number}"
      end
    end

    native_name { english_name }

    centre { Faker::Address.city }

    timezone { "#{[nil, :-].sample}#{rand(0..11).to_s.rjust(2, '0')}:00:00" }
  end
end
