# frozen_string_literal: true

class AsymmetricKeysController < ApplicationController
  # GET /public_keys
  def index
    authorize AsymmetricKey
    @asymmetric_keys = policy_scope(AsymmetricKey).page(params[:page])
  end
end
