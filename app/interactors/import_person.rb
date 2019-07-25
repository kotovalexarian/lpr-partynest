# frozen_string_literal: true

class ImportPerson
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      create_person
      create_general_comments_person_comment
      create_first_contact_date_person_comment
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

  def create_general_comments_person_comment
    return if general_comments.blank?

    context.general_comments_person_comment =
      context.person.person_comments.where(origin: :general_comments)
      .lock(true).first_or_initialize

    context.general_comments_person_comment.text = general_comments

    context.general_comments_person_comment.save!
  end

  def create_first_contact_date_person_comment
    return if first_contact_date.blank?

    context.first_contact_date_person_comment =
      context.person.person_comments.where(origin: :first_contact_date)
      .lock(true).first_or_initialize

    context.first_contact_date_person_comment.text = first_contact_date

    context.first_contact_date_person_comment.save!
  end

  def person_id
    context.row[0]
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

  def general_comments
    context.row[5]
  end

  def first_contact_date
    context.row[6]
  end
end
