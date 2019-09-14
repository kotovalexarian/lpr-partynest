# frozen_string_literal: true

class PrivateKeysController < ApplicationController
  before_action :set_asymmetric_key
  before_action :set_secret

  # GET /asymmetric_keys/:asymmetric_key_id/private_key
  def show
    authorize PrivateKey.new(@asymmetric_key)

    @asymmetric_key.decrypt_private_key_pem

    respond_to do |format|
      format.key do
        send_data @asymmetric_key.private_key_pem, filename: 'private.key'
      end
    end
  end

private

  def set_asymmetric_key
    @asymmetric_key = AsymmetricKey.find params[:asymmetric_key_id]
  end

  def set_secret
    @asymmetric_key.private_key_pem_secret =
      Base64.urlsafe_decode64 params[:private_key_pem_secret]
  end
end
