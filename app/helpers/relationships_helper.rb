# frozen_string_literal: true

module RelationshipsHelper
  def relationship_from_date_or_none(relationship)
    if relationship&.from_date.blank?
      none
    else
      localize relationship.from_date, format: :long
    end
  end
end
