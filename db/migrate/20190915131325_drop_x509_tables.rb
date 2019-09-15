# frozen_string_literal: true

class DropX509Tables < ActiveRecord::Migration[6.0]
  def change
    drop_table :x509_certificates
    drop_table :asymmetric_keys
  end
end
