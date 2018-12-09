# frozen_string_literal: true

namespace :puma do
  desc 'Restart Puma web server'
  task :restart do
    on roles(:web) do
      within release_path do
        statefile = File.join shared_path, 'tmp', 'pids', 'puma.state'
        execute :bundle, :exec, :pumactl, '--state', statefile, :restart
      end
    end
  end
end
