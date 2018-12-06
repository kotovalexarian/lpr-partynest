# frozen_string_literal: true

class PutMembershipAppToPool
  include Interactor

  def call
    pool.membership_pool_apps.where(membership_app: app).first_or_create!
  end

private

  def pool
    @pool ||= context.pool
  end

  def app
    @app ||= context.app
  end
end
