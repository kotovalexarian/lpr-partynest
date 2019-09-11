# frozen_string_literal: true

class Staffs::X509CertificatesController < ApplicationController
  before_action :set_x509_certificate, except: :index

  # GET /staff/x509_certificates
  def index
    authorize %i[staff x509_certificate]
    @x509_certificates = policy_scope(
      X509Certificate,
      policy_scope_class: Staff::X509CertificatePolicy::Scope,
    ).page(params[:page])
  end

  # GET /staff/x509_certificates/id
  def show
    authorize [:staff, @x509_certificate]
  end

private

  def set_x509_certificate
    @x509_certificate = X509Certificate.find params[:id]
  end
end
