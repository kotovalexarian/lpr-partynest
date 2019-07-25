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
    context.person =
      Person.where(id: context.person_id).lock(true).first_or_create!(
        person_attributes.reverse_merge(
          contacts_list: ContactsList.new,
        ),
      )
  end

  def create_general_comments_person_comment
    return if context.general_comments.blank?

    context.general_comments_person_comment =
      context.person.person_comments.where(origin: :general_comments)
      .lock(true).first_or_initialize

    context.general_comments_person_comment.text = context.general_comments

    context.general_comments_person_comment.save!
  end

  def create_first_contact_date_person_comment
    return if context.first_contact_date.blank?

    context.first_contact_date_person_comment =
      context.person.person_comments.where(origin: :first_contact_date)
      .lock(true).first_or_initialize

    context.first_contact_date_person_comment.text = context.first_contact_date

    context.first_contact_date_person_comment.save!
  end

  def person_attributes
    {
      last_name: context.last_name,
      first_name: context.first_name,
      middle_name: context.middle_name,
      sex: context.sex,
      date_of_birth: context.date_of_birth,
      place_of_birth: context.place_of_birth,
    }
  end
end
