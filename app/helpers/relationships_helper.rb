# frozen_string_literal: true

module RelationshipsHelper
  def relationship_status_or_none(relationship)
    translate_enum :relationship_status, relationship&.status || false
  end
end
