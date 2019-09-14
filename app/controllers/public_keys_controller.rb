# frozen_string_literal: true

class PublicKeysController < ApplicationController
  before_action :set_asymmetric_key

  # GET /asymmetric_keys/:asymmetric_key_id/public_key
  def show
    authorize @asymmetric_key

    respond_to do |format|
      format.pem do
        send_data @asymmetric_key.public_key_pem, filename: 'public.pem'
      end
    end
  end

private

  def set_asymmetric_key
    @asymmetric_key = AsymmetricKey.find params[:asymmetric_key_id]
  end
end
