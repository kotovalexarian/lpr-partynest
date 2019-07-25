# frozen_string_literal: true

module RequiredNameable
  extend ActiveSupport::Concern

  include Nameable

  included do
    validates :sex,            presence: true
    validates :date_of_birth,  presence: true
    validates :place_of_birth, presence: true
  end
end
