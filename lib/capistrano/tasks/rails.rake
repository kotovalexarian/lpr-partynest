# frozen_string_literal: true

namespace :load do
  task :defaults do
    set :rails_restart_roles, %i[web]
  end
end

namespace :rails do
  desc 'Restart app by touching tmp/restart.txt'
  task :restart do
    on roles(fetch(:rails_restart_roles)) do |_host|
      within release_path do
        execute :bundle, :exec, :rails, :restart
      end
    end
  end
end
