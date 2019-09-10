# frozen_string_literal: true

class CreateRSAPublicKeys < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :rsa_public_keys do |t|
      t.timestamps null: false

      t.text    :pem,  null: false
      t.integer :bits, null: false

      t.index :pem, unique: true
    end

    constraint :rsa_public_keys, :bits, <<~SQL
      bits in (2048, 4096)
    SQL
  end
end
