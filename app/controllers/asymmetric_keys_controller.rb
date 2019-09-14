# frozen_string_literal: true

class AsymmetricKeysController < ApplicationController
  before_action :set_asymmetric_key, except: :index

  # GET /asymmetric_keys
  def index
    authorize AsymmetricKey
    @asymmetric_keys = policy_scope(AsymmetricKey).page(params[:page])
  end

  # GET /asymmetric_keys/:id
  def show
    authorize @asymmetric_key
  end

private

  def set_asymmetric_key
    @asymmetric_key = AsymmetricKey.find params[:id]
  end
end
