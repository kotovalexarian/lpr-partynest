# frozen_string_literal: true

class PassportsController < ApplicationController
  # GET /passports
  def index
    @passports = policy_scope(Passport)
  end
end
