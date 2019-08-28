# frozen_string_literal: true

module RelationshipsHelper
  def relationship_from_date_or_none(relationship)
    if relationship&.from_date.blank?
      none
    else
      localize relationship.from_date, format: :long
    end
  end

  def relationship_status_or_none(relationship)
    translate_enum :relationship_status, relationship&.status || false
  end

  def relationship_position_or_none(relationship)
    if relationship&.position.nil?
      none
    else
      translate_enum :relationship_position, relationship.position
    end
  end

  def relationship_short_position_or_none(relationship)
    if relationship&.position.nil?
      none
    else
      translate_enum :relationship_short_position, relationship.position
    end
  end
end
