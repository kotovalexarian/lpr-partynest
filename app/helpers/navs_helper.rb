# frozen_string_literal: true

module NavsHelper
  NAV_TABS_LIST_HTML_CLASS = {
    tabs: 'nav nav-tabs  d-none d-sm-flex',
    pills: 'nav nav-pills d-flex d-sm-none flex-column',
  }.freeze

  def nav_tabs(scope_name, current_tab_name, options)
    capture do
      concat nav_tabs_list scope_name, current_tab_name, :tabs, options
      concat nav_tabs_list scope_name, current_tab_name, :pills, options
    end
  end

  def nav_sidebar(scope_name, current_tab_name, options)
    tag.div class: 'list-group' do
      options.each do |(k, v)|
        concat nav_sidebar_item scope_name, current_tab_name, k, *v
      end
    end
  end

  def nav_tabs_list(scope_name, current_tab_name, format, options)
    tag.ul class: NAV_TABS_LIST_HTML_CLASS[format] do
      options.each do |(k, v)|
        concat nav_tabs_item scope_name, current_tab_name, k, *v
      end
    end
  end

  def nav_tabs_item(scope_name, current_tab_name, tab_name, policy, url)
    tag.li class: 'nav-item' do
      if policy
        link_to translate(tab_name, scope: [:nav_tabs, scope_name]),
                url,
                class: "nav-link #{:active if current_tab_name == tab_name}"
      else
        link_to translate(tab_name, scope: [:nav_tabs, scope_name]),
                url,
                class: 'nav-link disabled',
                tabindex: -1,
                'aria-disabled': true
      end
    end
  end

  def nav_sidebar_item(scope_name, current_tab_name, tab_name, policy, url)
    if policy
      link_to translate(tab_name, scope: [:nav_tabs, scope_name]),
              url,
              class: 'list-group-item list-group-item-action ' \
                     "#{:active if current_tab_name == tab_name}"
    else
      link_to translate(tab_name, scope: [:nav_tabs, scope_name]),
              url,
              class: 'list-group-item list-group-item-action disabled',
              'aria-disabled': true
    end
  end
end
