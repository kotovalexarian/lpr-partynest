# frozen_string_literal: true

class CreateX509Tables < ActiveRecord::Migration[6.0]
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

    create_table :x509_certificate_requests do |t|
      t.timestamps null: false

      t.references :rsa_public_key, null: false, foreign_key: true

      t.string :distinguished_name, null: false
      t.text   :pem,                null: false
    end

    constraint :x509_certificate_requests, :distinguished_name, <<~SQL
      is_good_big_text(distinguished_name)
    SQL

    create_table :x509_certificates do |t|
      t.timestamps null: false

      t.references :x509_certificate_request, null: true, foreign_key: true

      t.text     :pem,        null: false
      t.datetime :not_before, null: false
      t.datetime :not_after,  null: false
    end
  end
end
