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
package 'screen' do
  ignore_failure true
end

installer = ::File.join(Chef::Config['file_cache_path'], node['nexpose']['installer']['bin'])

# Get Nexpose Installer
remote_file installer do
  source node['nexpose']['installer']['uri']
  checksum node['nexpose']['installer']['linux']['checksum']
  mode 0700
end

# Install Nexpose
execute 'install-nexpose' do
  user 'root'
  cwd Chef::Config['file_cache_path']
  command "#{installer.to_s} #{node['nexpose']['install_args'].join(' ')}"
  not_if { ::File.exists?(File.join(node['nexpose']['install_path']['linux'], 'shared')) }
end

# The init script for nexpose consoles and engines is named differently.
# This block is not within the service block itself as an init_command as the
# current version of Chef attempted call update-rc.d only with the provider
# name.
case node['nexpose']['component_type']
when 'typical', 'console'
  nexpose_init = 'nexposeconsole'
when 'engine'
  nexpose_init = 'nexposeengine'
else
  log "Invalid nexpose compontent_type specified: #{node['nexpose']['component_type']}. Valid component_types are typical and engine"
end

# Path to environment file is different for engines and consoles.
case node['nexpose']['component_type']
when 'typical', 'console'
  environment_file = ::File.join(node['nexpose']['install_path'][node['os']], 'nsc', 'CustomEnvironment.properties')
when 'engine'
  environment_file = ::File.join(node['nexpose']['install_path'][node['os']], 'nse', 'CustomEnvironment.properties')
else
  log "Invalid nexpose compontent_type specified: #{node['nexpose']['component_type']}. Valid component_types are typical and engine"
end

template environment_file do
  not_if { node['nexpose']['custom_properties'].empty? }
end

service nexpose_init do
  supports :status => true, :restart => true
  action node['nexpose']['service_action']
end

