# frozen_string_literal: true

module ApplicationHelper # rubocop:disable Metrics/ModuleLength
  def federal_subjects_controller?
    controller_path == 'federal_subjects'
  end

  def staff_controller?
    controller_path.start_with?('staff')
  end

  def timezones_collection
    [*negative_timezones_collection, *positive_timezones_collection].freeze
  end

  def display_sha1(str)
    str = String(str).upcase
    raise 'Invalid format for SHA-1' unless str.match?(/\A[A-F0-9]{40}\z/)

    tag.small do
      concat display_fingerprint str[0...20]
      concat tag.br
      concat display_fingerprint str[20..-1]
    end
  end

  def display_sha256(str)
    str = String(str).upcase
    raise 'Invalid format for SHA-256' unless str.match?(/\A[A-F0-9]{64}\z/)

    tag.small do
      concat display_fingerprint str[0...32]
      concat tag.br
      concat display_fingerprint str[32..-1]
    end
  end

  def display_fingerprint(str)
    tag.samp do
      String(str).strip.upcase.each_char.each_slice(2).map(&:join).join(':')
    end
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

  def bool_badge(value)
    if value
      tag.span class: 'badge badge-pill badge-success' do
        translate :yes
      end
    else
      tag.span class: 'badge badge-pill badge-secondary' do
        translate :no
      end
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
