# frozen_string_literal: true

class Staffs::X509CertificatesController < ApplicationController
  # GET /staff/x509_certificates
  def index
    authorize %i[staff x509_certificate]
    @x509_certificates = policy_scope(
      X509Certificate,
      policy_scope_class: Staff::X509CertificatePolicy::Scope,
    ).page(params[:page])
  end
end
