# frozen_string_literal: true

class CreateX509Tables < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :rsa_public_keys do |t|
      t.timestamps null: false

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

      t.references :rsa_public_key,           null: false, foreign_key: true
      t.references :x509_certificate_request, null: true,  foreign_key: true

      t.text     :pem,        null: false
      t.string   :subject,    null: false
      t.string   :issuer,     null: false
      t.datetime :not_before, null: false
      t.datetime :not_after,  null: false
    end
  end
end
