# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /passports' do
  let(:passport_attributes) { attributes_for :passport }

  def make_request
    post '/passports', params: { passport: passport_attributes }
  end

  specify do
    expect { make_request }.to change(Passport, :count).from(0).to(1)
  end

  context 'after request' do
    before { make_request }

    specify do
      expect(Passport.last).to have_attributes passport_attributes
    end
  end
end
