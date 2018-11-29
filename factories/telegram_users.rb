# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_user do
    remote_telegram_id { rand 1..1_000_000 }
    is_bot { [false, true].sample }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.username }
    language_code { I18n.available_locales.sample.to_s }
  end
end
