# frozen_string_literal: true

module Partynest
  module RSpecAccountRoleHelpers
    def create_account_type(account_type)
      return if account_type.nil?

      create "#{account_type}_account"
    end

    module ClassMethods
      def account_type_name(account_type)
        return 'no account' if account_type.nil?

        "#{account_type} account"
      end

      def for_account_types(*account_types, &block)
        account_types.each do |account_type|
          context "when #{account_type_name account_type} is authenticated" do
            let(:current_account) { create_account_type account_type }
            let(:account) { current_account }

            instance_eval(&block)
          end
        end
      end

      def xfor_account_types(*account_types, &block)
        account_types.each do |account_type|
          xcontext "when #{account_type_name account_type} is authenticated" do
            let(:current_account) { create_account_type account_type }
            let(:account) { current_account }

            instance_eval(&block)
          end
        end
      end
    end
  end
end
