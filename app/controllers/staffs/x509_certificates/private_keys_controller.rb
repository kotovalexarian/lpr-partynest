# frozen_string_literal: true

class Staffs::X509Certificates::PrivateKeysController < ApplicationController
  before_action :set_x509_certificate
  before_action :set_rsa_public_key

  # GET /staff/x509_certificates/:x509_certificate_id/private_key
  def show # rubocop:disable Metrics/MethodLength
    authorize [:staff, X509Certificate,
               PublicKeyPrivateKey.new(@rsa_public_key)]

    result = DecryptRSAPrivateKey.call(
      public_key: @rsa_public_key,
      private_key_pem_key: Base64.urlsafe_decode64(params[:private_key_secret]),
    )

    respond_to do |format|
      if result.success?
        format.key do
          send_data result.private_key_pem_cleartext, filename: 'private.key'
        end
      else
        format.key { render status: :unprocessable_entity, plain: '' }
      end
    end
  end

private

  def set_x509_certificate
    @x509_certificate = X509Certificate.find params[:x509_certificate_id]
  end

  def set_rsa_public_key
    @rsa_public_key = @x509_certificate.rsa_public_key
  end
end
