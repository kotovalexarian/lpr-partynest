# frozen_string_literal: true

namespace :puma do
  desc 'Stop Puma web server'
  task :stop do
    on roles(:web) do
      within release_path do
        statefile = File.join shared_path, 'tmp', 'pids', 'puma.state'
        execute :bundle, :exec, :pumactl, '--state', statefile, :stop
      end
    end
  end
end
