# frozen_string_literal: true

class AsymmetricKeysController < ApplicationController
  before_action :set_asymmetric_key, except: %i[index new create]

  # GET /asymmetric_keys
  def index
    authorize AsymmetricKey
    @asymmetric_keys = policy_scope(AsymmetricKey).page(params[:page])
  end

  # GET /asymmetric_keys/:id
  def show
    authorize @asymmetric_key

    respond_to do |format|
      format.html
      format.pem do
        send_data @asymmetric_key.public_key_pem, filename: 'public.pem'
      end
    end
  end

  # GET /asymmetric_keys/new
  def new
    @asymmetric_key_form = AsymmetricKeyForm.new
    authorize @asymmetric_key_form
  end

  # POST /asymmetric_keys
  def create
    @asymmetric_key_form = AsymmetricKeyForm.new asymmetric_key_form_params
    authorize @asymmetric_key_form

    return render :new unless @asymmetric_key_form.valid?

    result = ImportAsymmetricKey.call @asymmetric_key_form.attributes

    redirect_to after_create_url result.asymmetric_key
  end

private

  def set_asymmetric_key
    @asymmetric_key = AsymmetricKey.find params[:id]
  end

  def asymmetric_key_form_params
    params.require(:asymmetric_key).permit(
      :public_key_pem,
    )
  end

  def after_create_url(asymmetric_key)
    asymmetric_key_url(asymmetric_key)
  end
end
