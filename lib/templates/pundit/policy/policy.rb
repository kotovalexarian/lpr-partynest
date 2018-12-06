<% module_namespacing do -%>
# frozen_string_literal: true

class <%= class_name %>Policy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end
end
<% end -%>
