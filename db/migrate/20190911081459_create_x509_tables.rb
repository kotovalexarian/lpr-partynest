# frozen_string_literal: true

class CreateX509Tables < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :asymmetric_keys do |t|
      t.timestamps null: false
      t.string :type, null: false
      t.index %i[type id], unique: true

      t.text   :public_key_pem, null: false
      t.binary :public_key_der, null: false

      t.binary :private_key_pem_iv
      t.binary :private_key_pem_ciphertext

      t.integer :bits,   null: false
      t.string  :sha1,   null: false
      t.string  :sha256, null: false

      t.index :public_key_pem, unique: true
      t.index :public_key_der, unique: true
      t.index :sha1,           unique: true
      t.index :sha256,         unique: true
    end

    constraint :asymmetric_keys, :bits, <<~SQL
      bits in (2048, 4096)
    SQL

    create_table :x509_certificates do |t|
      t.timestamps null: false

      t.references :asymmetric_key, null: false, foreign_key: true

      t.text     :pem,        null: false
      t.string   :subject,    null: false
      t.string   :issuer,     null: false
      t.datetime :not_before, null: false
      t.datetime :not_after,  null: false
    end
  end
end
