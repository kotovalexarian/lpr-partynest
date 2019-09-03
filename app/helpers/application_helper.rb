# frozen_string_literal: true

module ApplicationHelper
  def federal_subjects_controller?
    controller_path == 'federal_subjects'
  end

  def staff_controller?
    controller_path.start_with?('staff')
  end

  def timezones_collection
    [*negative_timezones_collection, *positive_timezones_collection].freeze
  end

  def positive_timezones_collection
    0.upto(11).flat_map do |n|
      s = n.to_s.rjust(2, '0')

      [
        "#{s}:00:00",
        "#{s}:15:00",
        "#{s}:30:00",
        "#{s}:45:00",
      ]
    end
  end

  def negative_timezones_collection
    12.downto(1).flat_map do |n|
      s1 = n.to_s.rjust(2, '0')
      s2 = (n - 1).to_s.rjust(2, '0')

      [
        "-#{s1}:00:00",
        "-#{s2}:45:00",
        "-#{s2}:30:00",
        "-#{s2}:15:00",
      ]
    end
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
        tag.span { page_entries_info collection }
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
