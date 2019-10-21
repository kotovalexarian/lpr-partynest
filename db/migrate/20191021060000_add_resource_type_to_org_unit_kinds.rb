# frozen_string_literal: true

class AddResourceTypeToOrgUnitKinds < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    add_func :is_class_name, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN str ~ '^[A-Z][a-zA-Z0-9]*(::[A-Z][a-zA-Z0-9])*$';
      END;
      $$;
    SQL

    add_column :org_unit_kinds, :resource_type, :string, null: true

    add_constraint :org_unit_kinds, :resource_type, <<~SQL
      resource_type IS NULL OR is_class_name(resource_type)
    SQL
  end
end
