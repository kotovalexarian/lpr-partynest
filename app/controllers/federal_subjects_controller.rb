# frozen_string_literal: true

class FederalSubjectsController < ApplicationController
  before_action :set_federal_subject, except: :index

  # GET /federal_subjects
  def index
    authorize :federal_subject
    @federal_subjects = policy_scope(FederalSubject).order_by_display_name
  end

  # GET /federal_subjects/:id
  def show
    authorize @federal_subject
  end

private

  def set_federal_subject
    @federal_subject = FederalSubject.find params[:id]
  end
end
