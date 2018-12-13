# frozen_string_literal: true

module Partynest
  module RSpecAccountRoleHelpers
    def for_account_types(*account_types, &block)
      account_types.each do |account_type|
        account_type = :"#{account_type}_account" unless account_type.nil?

        context "when #{account_type || :no_account} is authenticated" do
          let(:current_account) { create account_type if account_type }
          let(:account) { current_account }

          instance_eval(&block)
        end
      end
    end
  end
end
