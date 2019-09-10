# frozen_string_literal: true

class AddUserAgentToSessions < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    add_column :sessions, :user_agent, :string, null: false, default: ''

    constraint :sessions, :user_agent, <<~SQL
      user_agent = '' OR is_good_big_text(user_agent)
    SQL
  end
end
