# frozen_string_literal: true

class Settings::PeopleController < ApplicationController
  before_action :set_account
  before_action :set_person_from_token, only: :new

  # GET /settings/person
  def show
    authorize %i[settings person]
  end

  # GET /settings/person/new
  def new
    authorize [:settings, @person]
    MergeAccountPerson.call account: @account, person: @person
    redirect_to %i[settings person]
  end

private

  def set_account
    @account = current_account.clone&.reload
  end

  def set_person_from_token
    @person = Person.find_by! account_connection_token: params[:token]
  end
end
