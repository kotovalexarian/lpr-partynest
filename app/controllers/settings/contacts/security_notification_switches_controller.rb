# frozen_string_literal: true

class Settings::Contacts::SecurityNotificationSwitchesController \
  < ApplicationController
  before_action :set_contact

  # POST /settings/contacts/:contact_id/security_notification_switch
  def create
    authorize [:settings, ContactSecurityNotificationSwitch.new(@contact)]

    @contact.send_security_notifications = !@contact.send_security_notifications
    @contact.save!

    redirect_to(
      settings_contacts_url,
      notice: translate_flash(
        @contact.send_security_notifications,
        value: @contact.value,
      ),
    )
  end

private

  def set_contact
    @contact = current_account&.contact_list&.contacts&.find params[:contact_id]
  end
end
