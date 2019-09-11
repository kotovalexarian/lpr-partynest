# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :context, :record

  delegate :account, :params, to: :context, allow_nil: true

  def initialize(context, record)
    @context = context
    @record = record
  end

  # :nocov:

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # :nocov:

  def policy(record)
    Pundit.policy account, record
  end

private

  def restricted?
    Rails.application.restricted?
  end

  class Scope
    attr_reader :context, :scope

    delegate :account, :params, to: :context, allow_nil: true

    def initialize(context, scope)
      @context = context
      @scope = scope
    end

    # :nocov:

    def resolve
      scope.none
    end

  # :nocov:

  private

    def restricted?
      Rails.application.restricted?
    end
  end

  class Context
    attr_reader :account, :params

    def initialize(account:, params:)
      @account = account
      @params = params
    end
  end
end
