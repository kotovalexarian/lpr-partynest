# frozen_string_literal: true

class AcceptAsSupporter
  include Interactor

  around :wrap_into_transaction

  after :reload_records

  def call
    context.person.all_relationships.create!(
      regional_office: context.regional_office,
      initiator_account: context.initiator_account,
      from_date: Time.zone.today,
      status: :supporter,
    )
  end

private

  def wrap_into_transaction(interactor)
    ActiveRecord::Base.transaction do
      interactor.call
    end
  end

  def reload_records
    context.person.reload
  end
end
