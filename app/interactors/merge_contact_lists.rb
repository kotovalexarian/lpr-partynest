# frozen_string_literal: true

class MergeContactLists
  include Interactor

  after do
    context.old_contact_list.contacts.reload
    context.new_contact_list.contacts.reload
  end

  def call
    ActiveRecord::Base.transaction do
      context.old_contact_list.contacts.each do |contact|
        contact.update! contact_list: context.new_contact_list
      end
    end
  end
end
