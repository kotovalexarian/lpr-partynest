# frozen_string_literal: true

class HomeController < ApplicationController
  # GET /
  def show
    authorize :home
  end
end
