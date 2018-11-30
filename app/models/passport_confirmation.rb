# frozen_string_literal: true

class PassportConfirmation < ApplicationRecord
  belongs_to :passport
  belongs_to :user

  validates :user_id, uniqueness: { scope: :passport_id }
end
