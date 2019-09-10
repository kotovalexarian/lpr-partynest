# frozen_string_literal: true

class CreateX509Certificates < ActiveRecord::Migration[6.0]
  def change
    create_table :x509_certificates do |t|
      t.timestamps null: false

      t.references :x509_certificate_request, null: true, foreign_key: true

      t.text :pem, null: false
    end
  end
end
