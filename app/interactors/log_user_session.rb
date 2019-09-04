# frozen_string_literal: true

class LogUserSession
  include Interactor

  def call
    create_session
    send_alerts
  end

private

  def contacts
    @contacts ||= context.user.account.contact_list.contacts
                         .where(send_security_notifications: true)
  end

  def create_session
    @session = Session.create!(
      account: context.user.account,
      logged_at: context.user.current_sign_in_at,
      ip_address: context.user.current_sign_in_ip,
    )
  end

  def send_alerts
    contacts.each do |contact|
      NotificationMailer.signed_in(contact.value, @session).deliver_now
    rescue
      nil
    end
  end
end
