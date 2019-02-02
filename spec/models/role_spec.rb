# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role do
  subject { create :role }

  describe '#name' do
    def allow_value(*)
      super.for :name
    end

    it { is_expected.to validate_presence_of :name }

    it { is_expected.not_to allow_value 'foobar' }

    it { is_expected.to allow_value 'superuser' }
  end

  pending '#human_name'
end
