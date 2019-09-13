# frozen_string_literal: true

class Staffs::X509Certificates::PrivateKeysController < ApplicationController
  before_action :set_x509_certificate
  before_action :set_asymmetric_key
  before_action :set_secret

  # GET /staff/x509_certificates/:x509_certificate_id/private_key
  def show
    authorize [:staff, X509Certificate, PrivateKey.new(@asymmetric_key)]

    @asymmetric_key.decrypt_private_key_pem

    respond_to do |format|
      format.key do
        send_data @asymmetric_key.private_key_pem, filename: 'private.key'
      end
    end
  end

private

  def set_x509_certificate
    @x509_certificate = X509Certificate.find params[:x509_certificate_id]
  end

  def set_asymmetric_key
    @asymmetric_key = @x509_certificate.asymmetric_key
  end

  def set_secret
    @asymmetric_key.private_key_pem_secret =
      Base64.urlsafe_decode64 params[:private_key_pem_secret]
  end
end
