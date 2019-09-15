# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks
  include ActiveRecord::AttributeAssignment

  def has_attribute?(name)
    attributes.key?(name.to_s)
  end

  def type_for_attribute(name)
    self.class.attribute_types[name.to_s]
  end
end
