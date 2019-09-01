# frozen_string_literal: true

class ImportRelationship
  include Interactor

  def call
    return if status.nil? || regional_office_id.nil?

    case status
    when :supporter then create_supporter_relationship
    when :member    then create_member_relationship
    when :excluded  then create_excluded_relationship
    else raise "Invalid status: #{status.inspect}"
    end
  end

private

  def person
    @person ||= Person.find person_id
  end

  def regional_office
    @regional_office ||= RegionalOffice.find regional_office_id
  end

  def create_supporter_relationship
    return if supporter_from_date.nil?

    Relationship.where(id: supporter_relationship_id).first_or_create!(
      person: person,
      regional_office: regional_office,
      from_date: supporter_from_date,
      status: :supporter,
    )
  end

  def create_member_relationship
    return if member_from_date.nil?

    Relationship.where(id: member_relationship_id).first_or_create!(
      person: person,
      regional_office: regional_office,
      from_date: member_from_date,
      status: :member,
      role: member_role,
    )
  end

  def create_excluded_relationship
    return if excluded_from_date.nil?

    Relationship.where(id: excluded_relationship_id).first_or_create!(
      person: person,
      regional_office: regional_office,
      from_date: excluded_from_date,
      status: :excluded,
    )
  end

  def supporter_relationship_id
    Integer(context.row[0]) * 5 + 0
  end

  def member_relationship_id
    Integer(context.row[0]) * 5 + 1
  end

  def excluded_relationship_id
    Integer(context.row[0]) * 5 + 2
  end

  def person_id
    context.row[1].presence
  end

  def regional_office_id
    context.row[2].presence
  end

  def status
    case context.row[3].to_i
    when 1 then :member
    when 3 then :supporter
    when 4 then :excluded
    end
  end

  def supporter_from_date
    member_from_date
  end

  def member_from_date
    m = /\A(\d\d)\.(\d\d)\.(\d\d\d\d)\z/.match context.row[4]
    return if m.nil?

    Date.new m[3].to_i, m[2].to_i, m[1].to_i
  end

  def excluded_from_date
    m = /\A(\d\d)\.(\d\d)\.(\d\d\d\d)\z/.match context.row[6]
    return if m.nil?

    Date.new m[3].to_i, m[2].to_i, m[1].to_i
  end

  def comment
    context.row[7].presence
  end

  def secretary?
    context.row[5] == 'Y'
  end

  def manager?
    secretary? || context.row[16] == 'Y'
  end

  def supervisor?
    context.row[15] == 'Y'
  end

  def member_role
    return :regional_supervisor if supervisor?
    return :regional_manager if manager?
  end

  def member_regional_secretary_flag
    return :regional_secretary if secretary?
  end
end
