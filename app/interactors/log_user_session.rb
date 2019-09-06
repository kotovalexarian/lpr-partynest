# frozen_string_literal: true

class LogUserSession
  include Interactor

  def call
    create_session
    send_email_alerts
    send_telegram_alerts
  end

private

  def contacts
    @contacts ||=
      context
      .user
      .account
      .contact_list
      .contacts
      .where(send_security_notifications: true)
  end

  def email_contacts
    @email_contacts ||=
      contacts
      .includes(:contact_network)
      .where(contact_networks: { codename: :email })
  end

  def telegram_contacts
    @telegram_contacts ||=
      contacts
      .includes(:contact_network)
      .where(contact_networks: { codename: :telegram_id })
  end

  def create_session
    @session = Session.create!(
      account: context.user.account,
      logged_at: context.user.current_sign_in_at,
      ip_address: context.user.current_sign_in_ip,
    )
  end

  def send_email_alerts
    email_contacts.each do |contact|
      NotificationMailer.signed_in(contact.value, @session).deliver_now
    rescue
      nil
    end
  end

  def send_telegram_alerts
    telegram_contacts.each do |contact|
      SendTelegramMessage.call(
        chat_id: contact.value,
        text: I18n.translate(:new_sign_in),
      )
    end
  end
end
