# frozen_string_literal: true

class Settings::Contacts::PublicSwitchesController < ApplicationController
  before_action :set_contact

  # POST /settings/contacts/:contact_id/public_switch
  def create
    authorize [:settings, ContactPublicSwitch.new(@contact)]

    @contact.show_in_public = !@contact.show_in_public
    @contact.save!

    redirect_to settings_contacts_url
  end

private

  def set_contact
    @contact = current_account&.contact_list&.contacts&.find params[:contact_id]
  end
end
