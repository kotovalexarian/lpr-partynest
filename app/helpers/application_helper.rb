# frozen_string_literal: true

module ApplicationHelper
  def federal_subjects_controller?
    controller_path == 'federal_subjects'
  end

  def staff_controller?
    controller_path.start_with?('staff')
  end

  def none
    tag.i class: 'text-muted' do
      translate :none
    end
  end

  def translate_enum(type, value)
    translate value, scope: [:enums, type]
  end

  def pagination(collection)
    tag.div do
      concat tag.div(class: 'd-flex justify-content-center') {
        paginate collection
      }

      concat tag.div(class: 'd-flex justify-content-center') {
        tag.span { page_entries_info(collection).capitalize }
      }
    end
  end

  def open_action(url)
    link_to url, role: :button, class: 'btn btn-light btn-sm' do
      concat tag.i class: 'far fa-eye'
      concat '&nbsp;'.html_safe
      concat translate :open_action
    end
  end

  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error', 'recaptcha_error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    else
      'alert-info'
    end
  end
end
