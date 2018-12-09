# frozen_string_literal: true

namespace :sidekiq do
  desc 'Stop Sidekiq app worker'
  task :stop do
    on roles(:app) do
      within release_path do
        pidfile = File.join shared_path, 'tmp', 'pids', 'sidekiq.pid'
        execute :bundle, :exec, :sidekiqctl, :stop, pidfile
      end
    end
  end
end
