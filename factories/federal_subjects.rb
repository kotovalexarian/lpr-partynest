# frozen_string_literal: true

FactoryBot.define do
  factory :federal_subject do
    initialize_with do
      FederalSubject.find_or_initialize_by(
        number: number,
        english_name: english_name,
        native_name: native_name,
      )
    end

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

  factory :moscow_federal_subject, parent: :federal_subject do
    number { 77 }
    english_name { 'Moscow' }
    native_name { 'Москва' }
    centre { 'Москва' }
    timezone { '03:00:00' }
  end

  factory :perm_federal_subject, parent: :federal_subject do
    number { 27 }
    english_name { 'Perm Krai' }
    native_name { 'Пермский край' }
    centre { 'Пермь' }
    timezone { '05:00:00' }
  end
end
