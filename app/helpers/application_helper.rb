# frozen_string_literal: true

module ApplicationHelper
  NAV_TABS_LIST_HTML_CLASS = {
    tabs: 'nav nav-tabs  d-none d-sm-flex',
    pills: 'nav nav-pills d-flex d-sm-none flex-column',
  }.freeze

  def federal_subjects_controller?
    controller_path == 'federal_subjects'
  end

  def staff_controller?
    controller_path.start_with?('staff')
  end

  def translate_enum(type, value)
    translate value, scope: [:enums, type]
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

  def nav_tabs(scope_name, current_tab_name, options)
    capture do
      concat nav_tabs_list scope_name, current_tab_name, :tabs, options
      concat nav_tabs_list scope_name, current_tab_name, :pills, options
    end
  end

  def nav_tabs_list(scope_name, current_tab_name, format, options)
    tag.ul class: NAV_TABS_LIST_HTML_CLASS[format] do
      options.each do |(k, v)|
        concat nav_tabs_item scope_name, current_tab_name, k, v
      end
    end
  end

  def nav_tabs_item(scope_name, current_tab_name, tab_name, url)
    tag.li class: 'nav-item' do
      link_to translate(tab_name, scope: [:nav_tabs, scope_name]),
              url,
              class: "nav-link #{:active if current_tab_name == tab_name}"
    end
  end
end
