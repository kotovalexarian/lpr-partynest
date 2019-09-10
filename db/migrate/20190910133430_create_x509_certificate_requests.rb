# frozen_string_literal: true

class CreateX509CertificateRequests < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :x509_certificate_requests do |t|
      t.timestamps null: false

      t.references :rsa_public_key, null: false, foreign_key: true

      t.string :distinguished_name, null: false
      t.text   :pem,                null: false
    end

    constraint :x509_certificate_requests, :distinguished_name, <<~SQL
      is_good_big_text(distinguished_name)
    SQL
  end
end
