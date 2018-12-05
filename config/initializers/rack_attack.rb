# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rack::Attack.throttle 'requests by IP', limit: 10, period: 1, &:ip
