# frozen_string_literal: true

class AddHierarchy < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  # rubocop:disable Rails/NotNullColumn

  def change
    rename_column :org_units, :parent_id, :parent_unit_id

    add_reference :relationships,
                  :parent_rel,
                  null: true,
                  index: true,
                  foreign_key: { to_table: :relationships }

    add_column :org_unit_kinds, :level, :integer, null: false
    add_column :org_units,      :level, :integer, null: false
    add_column :relationships,  :level, :integer, null: false

    add_constraint :org_unit_kinds, :level, 'level >= 0'
    add_constraint :org_units,      :level, 'level >= 0'
    add_constraint :relationships,  :level, 'level >= 0'

    add_constraint :org_unit_kinds, :parent_kind, 'parent_kind_id != id'
    add_constraint :org_units,      :parent_unit, 'parent_unit_id != id'
    add_constraint :relationships,  :parent_rel,  'parent_rel_id  != id'

    add_func_validate_org_unit_kind_hierarchy
    add_func_validate_org_unit_hierarchy
    add_func_validate_relationship_hierarchy

    add_trigger :org_unit_kinds,
                :validate_hierarchy,
                'BEFORE INSERT OR UPDATE',
                'validate_org_unit_kind_hierarchy()'

    add_trigger :org_units,
                :validate_hierarchy,
                'BEFORE INSERT OR UPDATE',
                'validate_org_unit_hierarchy()'

    add_trigger :relationships,
                :validate_hierarchy,
                'BEFORE INSERT OR UPDATE',
                'validate_relationship_hierarchy()'

    add_reference :relation_statuses,
                  :org_unit_kind,
                  null: false,
                  foreign_key: true
  end

  # rubocop:enable Rails/NotNullColumn

  def add_func_validate_org_unit_kind_hierarchy
    add_func :validate_org_unit_kind_hierarchy, <<~SQL
      () RETURNS trigger LANGUAGE plpgsql AS
      $$
      DECLARE
        parent_kind record;
      BEGIN
        IF NEW.parent_kind_id IS NULL THEN
          IF NEW.level != 0 THEN
            RAISE EXCEPTION 'level is invalid';
          END IF;

        ELSE
          SELECT *
            FROM org_unit_kinds
            INTO parent_kind
            WHERE id = NEW.parent_kind_id;

          IF parent_kind IS NULL THEN
            RAISE EXCEPTION 'can not find parent';
          END IF;

          IF NEW.level != parent_kind.level + 1 THEN
            RAISE EXCEPTION 'level is invalid';
          END IF;
        END IF;

        RETURN NEW;
      END;
      $$;
    SQL
  end

  def add_func_validate_org_unit_hierarchy
    add_func :validate_org_unit_hierarchy, <<~SQL
      () RETURNS trigger LANGUAGE plpgsql AS
      $$
      DECLARE
        kind record;
        parent_kind record;
        parent_unit record;
      BEGIN
        IF NEW.kind_id IS NULL THEN
          RAISE EXCEPTION 'does not have type';
        END IF;

        SELECT *
          FROM org_unit_kinds
          INTO kind
          WHERE id = NEW.kind_id;

        IF kind IS NULL THEN
          RAISE EXCEPTION 'can not find type';
        END IF;

        SELECT *
          FROM org_unit_kinds
          INTO parent_kind
          WHERE id = kind.parent_kind_id;

        IF (kind.parent_kind_id IS NULL) != (parent_kind IS NULL) THEN
          RAISE EXCEPTION 'can not find parent type';
        END IF;

        IF parent_kind IS NULL THEN
          IF NEW.parent_unit_id IS NOT NULL THEN
            RAISE EXCEPTION 'parent is invalid (expected NULL)';
          END IF;

          IF NEW.level != 0 THEN
            RAISE EXCEPTION 'level is invalid';
          END IF;

        ELSE
          IF NEW.parent_unit_id IS NULL THEN
            RAISE EXCEPTION 'parent is invalid (expected NOT NULL)';
          END IF;

          SELECT *
            FROM org_units
            INTO parent_unit
            WHERE id = NEW.parent_unit_id;

          IF parent_unit IS NULL THEN
            RAISE EXCEPTION 'can not find parent';
          END IF;

          IF parent_unit.kind_id != parent_kind.id THEN
            RAISE EXCEPTION 'parent is invalid';
          END IF;

          IF (
            NEW.level != kind.level            OR
            NEW.level != parent_kind.level + 1 OR
            NEW.level != parent_unit.level + 1
          ) THEN
            RAISE EXCEPTION 'level is invalid';
          END IF;
        END IF;

        RETURN NEW;
      END;
      $$;
    SQL
  end

  def add_func_validate_relationship_hierarchy
    add_func :validate_relationship_hierarchy, <<~SQL
      () RETURNS trigger LANGUAGE plpgsql AS
      $$
      DECLARE
        org_unit record;
        parent_unit record;
        parent_rel record;
      BEGIN
        IF NEW.org_unit_id IS NULL THEN
          RAISE EXCEPTION 'does not have org unit';
        END IF;

        SELECT *
          FROM org_units
          INTO org_unit
          WHERE id = NEW.org_unit_id;

        IF org_unit IS NULL THEN
          RAISE EXCEPTION 'can not find org unit';
        END IF;

        SELECT *
          FROM org_units
          INTO parent_unit
          WHERE id = org_unit.parent_unit_id;

        IF (org_unit.parent_unit_id IS NULL) != (parent_unit IS NULL) THEN
          RAISE EXCEPTION 'can not find parent org unit';
        END IF;

        IF parent_unit IS NULL THEN
          IF NEW.parent_rel_id IS NOT NULL THEN
            RAISE EXCEPTION 'parent rel is invalid (expected NULL)';
          END IF;

          IF NEW.level != 0 THEN
            RAISE EXCEPTION 'level is invalid (expected 0)';
          END IF;

        ELSE
          IF NEW.parent_rel_id IS NULL THEN
            RAISE EXCEPTION 'parent rel is invalid (expected NOT NULL)';
          END IF;

          SELECT *
            FROM relationships
            INTO parent_rel
            WHERE id = NEW.parent_rel_id;

          IF parent_rel IS NULL THEN
            RAISE EXCEPTION 'can not find parent rel';
          END IF;

          IF parent_rel.org_unit_id != parent_unit.id THEN
            RAISE EXCEPTION 'parent rel is invalid';
          END IF;

          IF (
            NEW.level != org_unit.level        OR
            NEW.level != parent_unit.level + 1 OR
            NEW.level != parent_rel.level  + 1
          ) THEN
          END IF;
        END IF;

        RETURN NEW;
      END;
      $$;
    SQL
  end
end
