# frozen_string_literal: true

class ChangeUserAgent < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    drop_constraint :sessions, :user_agent, <<~SQL
      user_agent = '' OR is_good_big_text(user_agent)
    SQL

    remove_column :sessions, :user_agent, :string, null: false, default: ''
    add_column    :sessions, :user_agent, :string, null: true

    constraint :sessions, :user_agent, <<~SQL
      user_agent IS NULL OR is_good_big_text(user_agent)
    SQL
  end
end
