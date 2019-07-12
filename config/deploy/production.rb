# frozen_string_literal: true

server 'partynest.libertarian-party.com', roles: %w[web app db]

append :linked_dirs, '.bundle'

namespace :deploy do
  after :finished, :change_group

  desc 'Change group'
  task :change_group do
    on roles(:all) do
      execute :chown, '-R', ':partynest', '/opt/partynest'
    end
  end
end
