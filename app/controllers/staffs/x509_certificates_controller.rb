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
      X509CertificateForm.new params.require(:x509_certificate).permit!

    authorize [:staff, @x509_certificate_form]

    return render :new unless @x509_certificate_form.valid?

    result = CreateRSAKeysAndX509SelfSignedCertificate.call \
      @x509_certificate_form.attributes

    return render :new unless result.success?

    redirect_to [:staff, result.certificate]
  end

private

  def set_x509_certificate
    @x509_certificate = X509Certificate.find params[:id]
  end
end
