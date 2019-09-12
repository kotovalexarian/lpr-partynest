# frozen_string_literal: true

class Staffs::X509CertificatesController < ApplicationController
  before_action :set_x509_certificate, except: %i[index new create]

  # GET /staff/x509_certificates
  def index
    authorize %i[staff x509_certificate]
    @x509_certificates = policy_scope(
      X509Certificate,
      policy_scope_class: Staff::X509CertificatePolicy::Scope,
    ).page(params[:page])
  end

  # GET /staff/x509_certificates/:id
  def show
    authorize [:staff, @x509_certificate]
  end

  # GET /staff/x509_certificates/new
  def new
    @x509_certificate_form = X509CertificateForm.new
    authorize [:staff, @x509_certificate_form]
  end

  # POST /staff/x509_certificates
  def create
    @x509_certificate_form =
      X509CertificateForm.new x509_certificate_form_params

    authorize [:staff, @x509_certificate_form]

    return render :new unless @x509_certificate_form.valid?

    result = CreateRSAKeysAndX509SelfSignedCertificate.call \
      @x509_certificate_form.attributes

    redirect_to staff_x509_certificate_url(
      result.certificate,
      private_key_secret: Base64.urlsafe_encode64(
        result.public_key.private_key_pem_secret,
      ),
    )
  end

private

  def set_x509_certificate
    @x509_certificate = X509Certificate.find params[:id]
  end

  def x509_certificate_form_params
    params.require(:x509_certificate).permit(
      :distinguished_name,
      :not_before,
      :not_after,
    )
  end
end
