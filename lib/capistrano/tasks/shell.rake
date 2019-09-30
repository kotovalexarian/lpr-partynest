# frozen_string_literal: true

# The MIT License (MIT)
#
# Copyright (c) 2015 Vladimir Kochnev
# Copyright (c) 2018-2019 Alex Kotov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

namespace :load do
  task :defaults do
    set :shell_server_number, ask('server number', 1)
  end
end

desc 'Opens SSH shell on remote host in current release directory'
task :shell do
  hosts = []

  on roles(:all), in: :sequence, wait: 0 do |host|
    hosts << host
  end

  if hosts.none?
    puts 'No servers matched'
    exit
  elsif hosts.length == 1
    set :shell_server_number, 1
  else
    hosts.each_with_index do |host, i|
      puts "#{i + 1}) #{host} (#{host.roles.to_a.join ' '})"
    end
  end

  i = fetch(:shell_server_number).to_i - 1
  host = hosts[i]
  options = host.netssh_options

  cmd = ['ssh', '-t']
  cmd << '-A' if options[:forward_agent]

  Array(options[:keys]).each do |key|
    cmd << '-i'
    cmd << key
  end

  if options[:port]
    cmd << '-p'
    cmd << options[:port]
  end

  cmd << [options[:user], host.hostname].compact.join('@')

  shell_cmd = '$SHELL --login'

  cmd << if host.properties.fetch(:no_release)
           shell_cmd
         else
           "cd #{release_path} && #{shell_cmd}"
         end

  puts "Executing #{cmd.join ' '}"
  exec(*cmd)
end
