# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rack::Attack.throttle 'req/ip', limit: 120, period: 60, &:ip

Rack::Attack.throttle 'user/email', limit: 20, period: 60 do |req|
  req.params['email'].presence if req.post? && req.path.start_with?('/users')
end
