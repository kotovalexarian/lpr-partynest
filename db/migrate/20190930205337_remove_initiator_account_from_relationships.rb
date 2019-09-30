# frozen_string_literal: true

class RemoveInitiatorAccountFromRelationships < ActiveRecord::Migration[6.0]
  def change
    remove_reference :relationships,
                     :initiator_account,
                     null: true,
                     index: true,
                     foreign_key: { to_table: :accounts }
  end
end
