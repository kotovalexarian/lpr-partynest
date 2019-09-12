# frozen_string_literal: true

class CreateX509CertificateRequest
  include Interactor

  def call
    context.certificate_request = X509CertificateRequest.create!(
      rsa_public_key: context.public_key,
      distinguished_name: context.distinguished_name,
      pem: request.to_pem.freeze,
    )
  end

private

  def private_key_pkey
    @private_key_pkey ||= OpenSSL::PKey::RSA.new context.private_key_pem
  end

  def public_key_pkey
    @public_key_pkey ||=
      OpenSSL::PKey::RSA.new context.public_key.public_key_pem
  end

  def subject
    @subject ||= OpenSSL::X509::Name.parse context.distinguished_name
  end

  def request
    @request ||= OpenSSL::X509::Request.new.tap do |request|
      request.version = 0
      request.public_key = public_key_pkey
      request.subject = subject
      request.sign private_key_pkey, OpenSSL::Digest::SHA256.new
    end
  end
end
