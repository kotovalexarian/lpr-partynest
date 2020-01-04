# frozen_string_literal: true

module PaginalController
  extend ActiveSupport::Concern

  def active_page
    params[:page]
  end
end
