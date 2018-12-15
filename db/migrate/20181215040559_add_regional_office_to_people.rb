# frozen_string_literal: true

class AddRegionalOfficeToPeople < ActiveRecord::Migration[5.2]
  def change
    add_reference :people, :regional_office, foreign_key: true
  end
end
