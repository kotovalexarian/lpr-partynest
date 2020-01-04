# frozen_string_literal: true

require 'elasticsearch/rails/tasks/import'

Rake::Task['elasticsearch:import:all'].prerequisites << :environment
Rake::Task['elasticsearch:import:model'].prerequisites << :environment
