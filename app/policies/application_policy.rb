# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :context, :record

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

  def account
    context&.account
  end

  def restricted?
    Rails.application.restricted?
  end

  class Scope
    attr_reader :context, :scope

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

    def account
      context&.account
    end

    def restricted?
      Rails.application.restricted?
    end
  end

  class Context
    attr_reader :account

    def initialize(account:)
      @account = account
    end
  end
end
