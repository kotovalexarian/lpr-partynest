# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH/PUT /passports/:id' do
  let!(:passport) { create :passport }

  let :passport_attributes do
    { image: Rack::Test::UploadedFile.new(File.open(passport_image_path)) }
  end

  let :passport_image_path do
    Rails.root.join 'fixtures', 'passport_image_1.jpg'
  end

  before do
    patch "/passports/#{passport.id}", params: { passport: passport_attributes }
  end

  specify do
    expect(response).to redirect_to passport_url passport
  end
end
