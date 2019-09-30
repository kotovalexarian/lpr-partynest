# frozen_string_literal: true

server 'alpha.libertarian-party.com',
       roles: [],
       no_release: true

server 'beta.libertarian-party.com',
       roles: %w[rvm web]

server 'gamma.libertarian-party.com',
       roles: %w[rvm web app db]
