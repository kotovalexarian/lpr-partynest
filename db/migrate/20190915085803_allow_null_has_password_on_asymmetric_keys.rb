# frozen_string_literal: true

class AllowNullHasPasswordOnAsymmetricKeys < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :asymmetric_keys, :has_password, :boolean, null: true
      end
      dir.down do
        change_column :asymmetric_keys, :has_password, :boolean, null: false
      end
    end
  end
end
