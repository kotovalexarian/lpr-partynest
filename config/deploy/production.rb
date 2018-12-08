# frozen_string_literal: true

server '138.197.0.6', roles: %w[web app db]

namespace :deploy do
  after :published, :restart

  desc 'Restart application services'
  task :restart do
    on roles(:web) do
      execute :sudo, :systemctl, :restart, 'partynest-web.service'
    end

    on roles(:app) do
      execute :sudo, :systemctl, :restart, 'partynest-worker.service'
    end
  end
end
