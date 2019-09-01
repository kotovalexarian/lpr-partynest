# frozen_string_literal: true

class Staffs::People::AccountConnectionLinksController < ApplicationController
  before_action :set_person

  # GET /staff/people/:person_id/account_connection_link/new
  def new
    authorize [:staff, @person, AccountConnectionLink.new(@person)]
  end

  # POST /staff/people/:person_id/account_connection_link
  def create
    authorize [:staff, @person, AccountConnectionLink.new(@person)]
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
