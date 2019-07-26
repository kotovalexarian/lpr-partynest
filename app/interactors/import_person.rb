# frozen_string_literal: true

class ImportPerson # rubocop:disable Metrics/ClassLength
  include Interactor

  def call # rubocop:disable Metrics/MethodLength
    ActiveRecord::Base.transaction do
      create_person
      create_passport
      create_general_comments_person_comment
      create_first_contact_date_person_comment
      create_latest_contact_date_person_comment
      create_human_readable_id_person_comment
      create_past_experience_person_comment
      create_aid_at_2014_elections_person_comment
      create_aid_at_2015_elections_person_comment
    end
  end

private

  def create_person
    context.person = Person.where(id: person_id).lock(true).first_or_create!(
      person_attributes.reverse_merge(
        contacts_list: ContactsList.new,
      ),
    )
  end

  # rubocop:disable Metrics/AbcSize

  def create_passport
    context.passport =
      Passport
      .where(person_id: context.person.id).lock(true).first_or_initialize

    context.passport.federal_subject = FederalSubject.find_by id: region_id

    passport_attributes.each do |(key, value)|
      context.passport.public_send "#{key}=", value
    end

    context.passport.save!
  rescue
    context.passport = nil
  end

  def create_general_comments_person_comment
    return if general_comments.blank?

    context.general_comments_person_comment =
      context
      .person.person_comments.where(origin: :general_comments).lock(true)
      .first_or_initialize

    context.general_comments_person_comment.text = general_comments

    context.general_comments_person_comment.save!
  end

  def create_first_contact_date_person_comment
    return if first_contact_date.blank?

    context.first_contact_date_person_comment =
      context
      .person.person_comments.where(origin: :first_contact_date).lock(true)
      .first_or_initialize

    context.first_contact_date_person_comment.text = first_contact_date

    context.first_contact_date_person_comment.save!
  end

  def create_latest_contact_date_person_comment
    return if latest_contact_date.blank?

    context.latest_contact_date_person_comment =
      context
      .person.person_comments.where(origin: :latest_contact_date).lock(true)
      .first_or_initialize

    context.latest_contact_date_person_comment.text = latest_contact_date

    context.latest_contact_date_person_comment.save!
  end

  def create_human_readable_id_person_comment
    return if human_readable_id.blank?

    context.human_readable_id_person_comment =
      context
      .person.person_comments.where(origin: :human_readable_id).lock(true)
      .first_or_initialize

    context.human_readable_id_person_comment.text = human_readable_id

    context.human_readable_id_person_comment.save!
  end

  def create_past_experience_person_comment
    return if past_experience.blank?

    context.past_experience_person_comment =
      context
      .person.person_comments.where(origin: :past_experience).lock(true)
      .first_or_initialize

    context.past_experience_person_comment.text = past_experience

    context.past_experience_person_comment.save!
  end

  def create_aid_at_2014_elections_person_comment
    return if aid_at_2014_elections.blank?

    context.aid_at_2014_elections_person_comment =
      context
      .person.person_comments.where(origin: :ait_at_2014_elections).lock(true)
      .first_or_initialize

    context.aid_at_2014_elections_person_comment.text = ait_at_2014_elections

    context.aid_at_2014_elections_person_comment.save!
  end

  def create_aid_at_2015_elections_person_comment
    return if aid_at_2015_elections.blank?

    context.aid_at_2015_elections_person_comment =
      context
      .person.person_comments.where(origin: :ait_at_2015_elections).lock(true)
      .first_or_initialize

    context.aid_at_2015_elections_person_comment.text = ait_at_2015_elections

    context.aid_at_2015_elections_person_comment.save!
  end

  def person_id
    context.row[0]
  end

  def region_id
    context.row[14]
  end

  def person_attributes
    {
      last_name: context.row[2],
      first_name: context.row[1],
      middle_name: context.row[3],
      sex: nil,
      date_of_birth: context.row[8],
      place_of_birth: context.row[9],
    }
  end

  def passport_attributes # rubocop:disable Metrics/MethodLength
    {
      last_name: context.row[2],
      first_name: context.row[1],
      middle_name: context.row[3],
      sex: :male,
      date_of_birth: context.row[8],
      place_of_birth: context.row[9],

      series: context.row[38],
      number: context.row[10],
      issued_by: context.row[11],
      unit_code: context.row[12],
      date_of_issue: context.row[13],
      zip_code: context.row[15],

      town_type: context.row[20],
      town_name: context.row[21],
      settlement_type: context.row[22],
      settlement_name: context.row[23],
      district_type: context.row[18],
      district_name: context.row[19],
      street_type: context.row[16],
      street_name: context.row[17],
      residence_type: context.row[24],
      residence_name: context.row[25],
      building_type: context.row[26],
      building_name: context.row[27],
      apartment_type: context.row[28],
      apartment_name: context.row[29],
    }
  end

  # rubocop:enable Metrics/AbcSize

  def general_comments
    context.row[5]
  end

  def first_contact_date
    context.row[6]
  end

  def latest_contact_date
    context.row[7]
  end

  def human_readable_id
    context.row[34]
  end

  def past_experience
    context.row[35]
  end

  def ait_at_2014_elections
    context.row[36]
  end

  def ait_at_2015_elections
    context.row[37]
  end
end
