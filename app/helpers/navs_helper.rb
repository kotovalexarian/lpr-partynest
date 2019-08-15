# frozen_string_literal: true

module NavsHelper
  NAV_TABS_LIST_HTML_CLASS = {
    tabs: 'nav nav-tabs  d-none d-sm-flex',
    pills: 'nav nav-pills d-flex d-sm-none flex-column',
  }.freeze

  def nav_breadcrumb(*args, active_text)
    tag.nav 'aria-label': 'breadcrumb' do
      tag.ol class: 'breadcrumb' do
        args.each do |(text, url)|
          concat nav_breadcrumb_item text, url
        end
        concat nav_breadcrumb_item active_text
      end
    end
  end

  def nav_breadcrumb_item(text, url = nil)
    if url
      tag.li class: 'breadcrumb-item' do
        link_to text, url
      end
    else
      tag.li class: 'breadcrumb-item active', 'aria-current': 'page' do
        text
      end
    end
  end

  def nav_tabs(scope_name, active_tab_name, options)
    capture do
      concat nav_tabs_list scope_name, active_tab_name, :tabs, options
      concat nav_tabs_list scope_name, active_tab_name, :pills, options
    end
  end

  def nav_sidebar(scope_name, active_tab_name, options)
    tag.div class: 'list-group' do
      options.each do |(k, v)|
        concat nav_sidebar_item scope_name, active_tab_name, k, *v
      end
    end
  end

  def nav_tabs_list(scope_name, active_tab_name, format, options)
    tag.ul class: NAV_TABS_LIST_HTML_CLASS[format] do
      options.each do |(k, v)|
        concat nav_tabs_item scope_name, active_tab_name, k, *v
      end
    end
  end

  def nav_tabs_item(scope_name, active_tab_name, tab_name, policy, url)
    tag.li class: 'nav-item' do
      link_to translate(tab_name, scope: [:nav_tabs, scope_name]),
              url,
              nav_tab_link_options(policy, tab_name == active_tab_name)
    end
  end

  def nav_sidebar_item(scope_name, active_tab_name, tab_name, policy, url)
    link_to translate(tab_name, scope: [:nav_tabs, scope_name]),
            url,
            nav_sidebar_link_options(policy, tab_name == active_tab_name)
  end

  def nav_tab_link_options(policy, active)
    if policy
      { class: "nav-link #{:active if active}" }
    else
      { class: 'nav-link disabled', tabindex: -1, 'aria-disabled': true }
    end
  end

  def nav_sidebar_link_options(policy, active)
    if policy
      { class: "list-group-item list-group-item-action #{:active if active}" }
    else
      { class: 'list-group-item list-group-item-action disabled',
        'aria-disabled': true }
    end
  end
end
