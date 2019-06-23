# frozen_string_literal: true

class FederalSubjectsController < ApplicationController
  before_action :set_country_state, except: :index

  # GET /country_states
  def index
    authorize :country_state
    @country_states = policy_scope(FederalSubject)
  end

  # GET /country_states/:id
  def show
    authorize @country_state
  end

private

  def set_country_state
    @country_state = FederalSubject.find params[:id]
  end
end
