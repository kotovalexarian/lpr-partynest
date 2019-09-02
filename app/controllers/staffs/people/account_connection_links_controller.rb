# frozen_string_literal: true

class Staffs::People::AccountConnectionLinksController < ApplicationController
  before_action :set_person

  # GET /staff/people/:person_id/account_connection_link
  def show
    authorize [:staff, @person, AccountConnectionLink.new(@person)]
  end

  # POST /staff/people/:person_id/account_connection_link
  def create
    authorize [:staff, @person, AccountConnectionLink.new(@person)]
    @person.generate_account_connection_token
    redirect_to staff_person_account_connection_link_url(@person)
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
