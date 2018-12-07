# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_chat do
    remote_id { rand(-100_000_000..100_000_000) }
    chat_type { TelegramChat::CHAT_TYPES.sample }

    title      { Faker::Lorem.sentence }
    username   { Faker::Internet.username }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
  end
end
