# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

require 'bootsnap'

cache_dir = File.join(File.expand_path('..', __dir__), 'tmp', 'cache')

env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || ENV['ENV']

development_mode = ['', nil, 'development'].include?(env)
test_mode        = env == 'test'

Bootsnap.setup(
  cache_dir:            cache_dir,
  development_mode:     development_mode,
  load_path_cache:      true,
  autoload_paths_cache: true,
  disable_trace:        false,
  compile_cache_iseq:   test_mode,
  compile_cache_yaml:   true,
)
