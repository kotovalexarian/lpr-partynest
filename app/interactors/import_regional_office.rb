# frozen_string_literal: true

class ImportRegionalOffice
  include Interactor

  def call
    federal_subject = FederalSubject.find federal_subject_id

    context.regional_office =
      RegionalOffice.where(id: regional_office_id).first_or_create!(
        federal_subject: federal_subject,
        name: name,
      )
  end

private

  def regional_office_id
    context.row[0].presence
  end

  def federal_subject_id
    context.row[2].presence
  end

  def name
    context.row[1].presence
  end
end
