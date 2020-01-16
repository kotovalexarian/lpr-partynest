# frozen_string_literal: true

Spring.watch(
  '.ruby-version',
  '.ruby-gemset',
  '.rbenv-vars',
  'tmp/restart.txt',
  'tmp/caching-dev.txt',
)
