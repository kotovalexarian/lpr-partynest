# frozen_string_literal: true

class MergeContactLists
  include Interactor

  after do
    context.from.contacts.reload
    context.to.contacts.reload
  end

  def call
    ActiveRecord::Base.transaction do
      context.from.contacts.each do |contact|
        contact.update! contact_list: context.to
      end
    end
  end
end
