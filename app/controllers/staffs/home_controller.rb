# frozen_string_literal: true

class Staffs::HomeController < ApplicationController
  # GET /staff
  def show
    authorize %i[staff home]
  end
end
