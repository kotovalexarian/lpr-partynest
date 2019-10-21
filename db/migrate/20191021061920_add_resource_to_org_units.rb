# frozen_string_literal: true

class AddResourceToOrgUnits < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    reversible do |dir|
      dir.up do
        execute 'ALTER SEQUENCE org_units_id_seq RESTART WITH 1000'
      end
    end

    add_reference :org_units, :resource, polymorphic: true, null: true

    add_func_validate_org_unit_resource

    add_trigger :org_units,
                :add_func_validate_org_unit_resource,
                'BEFORE INSERT OR UPDATE',
                'add_func_validate_org_unit_resource()'
  end

  def add_func_validate_org_unit_resource
    add_func :add_func_validate_org_unit_resource, <<~SQL
      () RETURNS trigger LANGUAGE plpgsql AS
      $$
      DECLARE
        org_unit_kind record;
      BEGIN
        IF NEW.kind_id IS NULL THEN
          IF NEW.resource_type IS NOT NULL THEN
            RAISE EXCEPTION 'resource type is invalid (expected NULL)';
          END IF;

          IF NEW.resource_id IS NOT NULL THEN
            RAISE EXCEPTION 'resource ID is invalid (expected NULL)';
          END IF;

          RETURN NEW;
        END IF;

        SELECT * FROM org_unit_kinds INTO org_unit_kind WHERE id = NEW.kind_id;

        IF org_unit_kind IS NULL THEN
          RAISE EXCEPTION 'can not find type';
        END IF;

        IF org_unit_kind.resource_type IS NULL THEN
          IF NEW.resource_type IS NOT NULL THEN
            RAISE EXCEPTION 'resource type is invalid (expected NULL)';
          END IF;

          IF NEW.resource_id IS NOT NULL THEN
            RAISE EXCEPTION 'resource ID is invalid (expected NULL)';
          END IF;
        ELSE
          IF NEW.resource_type IS NULL THEN
            RAISE EXCEPTION 'resource type is invalid (expected NOT NULL)';
          END IF;

          IF NEW.resource_type != org_unit_kind.resource_type THEN
            RAISE EXCEPTION 'resource type is invalid';
          END IF;

          IF NEW.resource_id IS NULL THEN
            RAISE EXCEPTION 'resource ID is invalid (expected NULL)';
          END IF;
        END IF;

        RETURN NEW;
      END;
      $$;
    SQL
  end
end
