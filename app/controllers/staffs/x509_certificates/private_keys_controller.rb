# frozen_string_literal: true

class Staffs::X509Certificates::PrivateKeysController < ApplicationController
  before_action :set_x509_certificate
  before_action :set_rsa_public_key

  # GET /staff/x509_certificates/:x509_certificate_id/private_key
  def show
    authorize [:staff, X509Certificate, PublicKeyPrivateKey.new(@rsa_public_key)]

    cipher = OpenSSL::Cipher::AES256.new
    cipher.decrypt
    cipher.iv = @rsa_public_key.private_key_pem_iv
    cipher.key = Base64.urlsafe_decode64 params[:private_key_secret]

    cleartext = [
      cipher.update(@rsa_public_key.private_key_pem_ciphertext),
      cipher.final,
    ].join

    respond_to do |format|
      format.key { send_data cleartext, filename: 'private.key' }
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
