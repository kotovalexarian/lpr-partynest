# frozen_string_literal: true

class FederalSubjectsController < ApplicationController
  include PaginalController

  before_action :set_federal_subject, except: :index

  # GET /federal_subjects
  def index
    authorize :federal_subject
    @federal_subjects = policy_scope(FederalSubject).order_by_display_name
                                                    .page(active_page)
  end

  # GET /federal_subjects/:number
  def show
    authorize @federal_subject
  end

private

  def set_federal_subject
    @federal_subject = FederalSubject.find_by! number: params[:number]
  end
end
