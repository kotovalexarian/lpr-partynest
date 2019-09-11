# frozen_string_literal: true

class CreateX509SelfSignedCertificate
  include Interactor

  before do
    context.not_before = Time.at(context.not_before).utc
    context.not_after  = Time.at(context.not_after).utc
  end

  def call
    context.certificate = X509Certificate.create!(
      pem: cert.to_pem.freeze,
      subject: cert.subject.to_s,
      issuer: cert.issuer.to_s,
      not_before: cert.not_before,
      not_after: cert.not_after,
    )
  end

private

  def private_key_pkey
    @private_key_pkey ||= OpenSSL::PKey::RSA.new context.private_key_pem
  end

  def public_key_pkey
    @public_key_pkey ||= OpenSSL::PKey::RSA.new context.public_key.pem
  end

  def subject
    @subject ||= OpenSSL::X509::Name.parse context.distinguished_name
  end

  def cert # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @cert ||= OpenSSL::X509::Certificate.new.tap do |cert|
      cert.version = 2
      cert.serial = SecureRandom.rand 0...(2**16)
      cert.subject = subject
      cert.issuer = cert.subject
      cert.public_key = public_key_pkey
      cert.not_before = context.not_before
      cert.not_after = context.not_after

      AddExtensions.call cert

      cert.sign private_key_pkey, OpenSSL::Digest::SHA256.new
    end
  end

  class AddExtensions
    def self.call(cert)
      new(cert).call
    end

    def initialize(cert)
      @cert = cert
    end

    def call
      cert.add_extension basic_constraints
      cert.add_extension key_usage
      cert.add_extension subject_key_ident
      cert.add_extension authority_key_ident
    end

  private

    attr_reader :cert

    def ext_factory
      @ext_factory ||= OpenSSL::X509::ExtensionFactory.new.tap do |ext_factory|
        ext_factory.subject_certificate = cert
        ext_factory.issuer_certificate = cert
      end
    end

    def basic_constraints
      @basic_constraints ||= ext_factory.create_extension(
        'basicConstraints',
        'CA:TRUE',
        true,
      )
    end

    def key_usage
      @key_usage ||= ext_factory.create_extension(
        'keyUsage',
        'keyCertSign, cRLSign',
        true,
      )
    end

    def subject_key_ident
      @subject_key_ident ||= ext_factory.create_extension(
        'subjectKeyIdentifier',
        'hash',
        false,
      )
    end

    def authority_key_ident
      @authority_key_ident ||= ext_factory.create_extension(
        'authorityKeyIdentifier',
        'keyid:always,issuer:always',
        false,
      )
    end
  end
end
