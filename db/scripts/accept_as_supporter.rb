# frozen_string_literal: true

class AcceptAsSupporterProgram
  attr_reader :current_account, :person, :federal_subject

  def initialize(current_account, person, federal_subject)
    self.current_account = current_account
    self.person = person
    self.federal_subject = federal_subject
  end

  def active?
    latest_lpr_relationship.nil?
  end

  def call
    [lpr_rel, reg_dept_rel] if active?
  end

private

  def current_account=(value)
    unless value.instance_of? Account
      raise TypeError, "Expected #{Account}, got #{value.class}"
    end
    raise 'Expected record to be persisted' unless value.persisted?

    @current_account = value
  end

  def person=(value)
    unless value.instance_of? Person
      raise TypeError, "Expected #{Person}, got #{value.class}"
    end
    raise 'Expected record to be persisted' unless value.persisted?

    @person = value
  end

  def federal_subject=(value)
    unless value.instance_of? FederalSubject
      raise TypeError, "Expected #{FederalSubject}, got #{value.class}"
    end
    raise 'Expected record to be persisted' unless value.persisted?

    @federal_subject = value
  end

  #####################
  # Relation statuses #
  #####################

  def included_rel_status
    @included_rel_status ||= RelationStatus.find_by! codename: :included
  end

  def supporter_rel_status
    @supporter_rel_status ||= RelationStatus.find_by! codename: :supporter
  end

  #############################
  # Organizational unit types #
  #############################

  def lpr_org_unit_kind
    @lpr_org_unit_kind ||= OrgUnitKind.find_by! codename: :lpr
  end

  def reg_dept_org_unit_kind
    @reg_dept_org_unit_kind ||= OrgUnitKind.find_by! codename: :reg_dept
  end

  ########################
  # Organizational units #
  ########################

  def lpr_org_unit
    @lpr_org_unit ||=
      lpr_org_unit_kind
      .instances
      .order(created_at: :asc)
      .first
  end

  def reg_dept_org_unit
    @reg_dept_org_unit ||=
      reg_dept_org_unit_kind
      .instances
      .where(resource: federal_subject)
      .order(created_at: :asc)
      .first
  end

  ######################
  # Manipulated person #
  ######################

  def current_person
    @current_person ||= current_account.person
  end

  def latest_lpr_relationship
    if instance_variable_defined? :@latest_lpr_relationship
      return @latest_lpr_relationship
    end

    @latest_lpr_relationship =
      person
      .all_relationships
      .where(org_unit: lpr_org_unit)
      .order(from_date: :asc)
      .last
  end

  ####################
  # Generated values #
  ####################

  def from_date
    @from_date ||= Time.zone.now.to_date
  end

  def lpr_rel
    @lpr_rel ||= Relationship.create!(
      org_unit: lpr_org_unit,
      parent_rel: nil,
      status: included_rel_status,
      person: person,
      from_date: from_date,
    )
  end

  def reg_dept_rel
    @reg_dept_rel ||= Relationship.create!(
      org_unit: reg_dept_org_unit,
      parent_rel: lpr_rel,
      status: supporter_rel_status,
      person: person,
      from_date: from_date,
    )
  end
end
