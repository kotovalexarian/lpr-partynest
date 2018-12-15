# frozen_string_literal: true

class AddSupporterSinceToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :supporter_since, :date
  end
end
