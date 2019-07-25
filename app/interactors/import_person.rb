# frozen_string_literal: true

class ImportPerson
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      create_person
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
