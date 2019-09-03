# frozen_string_literal: true

class Settings::ContactsController < ApplicationController
  before_action :skip_policy_scope, only: :index

  before_action :set_contact_list
  before_action :set_contact, except: :index

  # GET /settings/contacts
  def index
    authorize %i[settings contact]
    @contacts = @contact_list.contacts
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

  def set_contact
    @contact = Contact.find params[:id]
  end
end
