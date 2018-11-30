# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /passports' do
  let(:passport_plain_attributes) { attributes_for :passport }

  let :passport_all_attributes do
    passport_plain_attributes.merge(
      image: Rack::Test::UploadedFile.new(File.open(passport_image_path)),
    )
  end

  let :passport_image_path do
    Rails.root.join 'fixtures', 'passport_image_1.jpg'
  end

  def make_request
    post '/passports', params: { passport: passport_all_attributes }
  end

  specify do
    expect { make_request }.to change(Passport, :count).from(0).to(1)
  end

  context 'after request' do
    before { make_request }

    specify do
      expect(response).to redirect_to passport_url Passport.last
    end

    specify do
      expect(Passport.last).to have_attributes passport_plain_attributes
    end

    specify do
      expect(Passport.last.image).to be_attached
    end
  end
end
