#
# Cookbook Name:: nexpose
# Recipe:: linux
#
# Copyright (C) 2013-2014, Rapid7, LLC.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install Nexpose Pre-Reqs
package 'screen'

installer = ::File.join(Chef::Config['file_cache_path'], node['nexpose']['installer']['bin'])

# Get Nexpose Installer
remote_file installer do
  source ::URI.join(node['nexpose']['installer']['uri'], node['nexpose']['installer']['bin']).to_s
  checksum node['nexpose']['installer']['checksum']
  mode 0700
  not_if { ::File.exist?(installer) }
end

# Init script for engine is different form console
case node['nexpose']['engine']
when true
  init_script = 'nexposeengine.rc'
else
  init_script = 'nexposeconsole.rc'
end

# There is a bug in the init script shipped with Nexpose in which the
# status command always returns a zero exit code. This makes it impossible
# for Chef to correctly determine if a process is actually running.
service 'nexpose' do
  service_name init_script
  start_command "/etc/init.d/#{init_script} start"
  stop_command "/etc/init.d/#{init_script} stop"
  restart_command "/etc/init.d/#{init_script} restart"
  supports :status => false, :restart => true
  action :nothing
end

# Install Nexpose
# In order to set database settings, Nexpose has to go through its initialization
# phase. Currently, the best way to figure out if Nexpose is complete with the init
# process is to execute a stop through the startup script. The Nexpose process traps
# the signal and remains running until the setup process is complete.
execute 'install-nexpose' do
  user 'root'
  cwd Chef::Config['file_cache_path']
  command "#{installer} #{node['nexpose']['install_args'].join(' ')}"
  creates File.join(node['nexpose']['installer']['path'], 'shared')
  notifies :run, 'execute[init]', :immediately
  notifies :enable, 'service[nexpose]', :immediately
end

# The Nexpose install takes a few seconds to start up. Sleep for 5 seconds to give
# it enough time to being the init process.
execute 'init' do
  user 'root'
  command "/etc/init.d/#{init_script} start && sleep 10 && /etc/init.d/#{init_script} stop"
  action :nothing
  notifies :start, 'service[nexpose]', :immediately
end

database_file = ::File.join(node['nexpose']['installer']['path'], 'nsc/nxpgsql/nxpdata/postgresql.conf')
template database_file do
  user 'nxpgsql'
  group 'nxpgsql'
  mode 0600
  variables(
    :shared_buffers => node['nexpose']['postgresql']['shared_buffers'],
    :max_connections => node['nexpose']['postgresql']['max_connections'],
    :work_mem => node['nexpose']['postgresql']['work_mem'],
    :checkpoint_segments => node['nexpose']['postgresql']['checkpoint_segments'],
    :effective_cache_size => node['nexpose']['postgresql']['effective_cache_size'],
    :log_min_error_statement => node['nexpose']['postgresql']['log_min_error_statement'],
    :log_min_duration_statement => node['nexpose']['postgresql']['log_min_duration_statement'],
    :wal_buffers => node['nexpose']['postgresql']['wal_buffers'],
    :maintenance_work_mem => node['nexpose']['postgresql']['maintenance_work_mem'],
  )
  notifies :restart, 'service[nexpose]', :delayed
  not_if { node['nexpose']['engine'] }
end
