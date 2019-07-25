# frozen_string_literal: true

module Nameable
  extend ActiveSupport::Concern

  included do
    pg_enum :sex, %i[male female]

    before_validation :turn_blank_nameable_attributes_into_nils

    validates :last_name,  presence: true
    validates :first_name, presence: true
  end

  def turn_blank_nameable_attributes_into_nils
    %i[
      last_name first_name middle_name sex date_of_birth place_of_birth
    ].each do |attribute|
      public_send "#{attribute}=", nil if public_send(attribute).blank?
    end
  end
end
