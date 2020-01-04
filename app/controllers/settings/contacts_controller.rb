# frozen_string_literal: true

class Settings::ContactsController < ApplicationController
  include PaginalController

  before_action :skip_policy_scope, only: :index

  before_action :set_contact_list

  before_action :new_contact,   only: :index
  before_action :build_contact, only: :create
  before_action :set_contact,   only: :destroy

  # GET /settings/contacts
  def index
    authorize [:settings, Contact]

    @contacts = @contact_list.contacts.page(active_page)
  end

  # POST /settings/contacts
  def create
    authorize [:settings, @contact]

    return render :index unless @contact.save

    redirect_to settings_contacts_url
  end

  # DELETE /settings/contacts/:id
  def destroy
    authorize [:settings, @contact]

    @contact.destroy!

    redirect_to(
      settings_contacts_url,
      notice: translate_flash(
        network_name: @contact.contact_network.name,
        value: @contact.value,
      ),
    )
  end

private

  def set_contact_list
    @contact_list = current_account&.contact_list
  end

  def new_contact
    @contact = Contact.new
  end

  def build_contact
    @contact = Contact.new permitted_attributes [:settings, Contact]
    @contact.contact_list = @contact_list
  end

  def set_contact
    @contact = Contact.find params[:id]
  end
end
