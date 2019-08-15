# frozen_string_literal: true

module RelationshipsHelper
  def relationship_status(relationship)
    translate(
      relationship.nil? ? :not_in_party : relationship.status,
      scope: %i[helpers person_status],
    )
  end
end
