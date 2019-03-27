# frozen_string_literal: true

class Staff::HomeController < ApplicationController
  # GET /staff
  def show
    authorize %i[staff home]
  end
end
