#
# Cookbook Name:: nexpose
# Recipe:: default
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
package "screen"

# Get Nexpose Installer
remote_file File.join(Chef::Config['file_cache_path'], node['nexpose']['installer']['bin'].to_s) do
  source node['nexpose']['installer']['uri']
  mode 0700
end

# Configure template response.varfile
template File.join(Chef::Config['file_cache_path'], 'response.varfile') do
  source "response.varfile.erb"
  mode 0644
end

# Set Variables for bash block
installer = File.join(Chef::Config['file_cache_path'], "#{node['nexpose']['installer']['bin']}")
console_mode = node['nexpose']['console_mode']
install_dir = node['nexpose']['install_dir']
install_path = node['nexpose']['install_path']
quiet_mode = node['nexpose']['quiet_mode']
var_file = node['nexpose']['var_file']
response_file = File.join(Chef::Config['file_cache_path'], "response.varfile")

# Install Nexpose
bash "install-nexpose" do
  user "root"
  cwd Chef::Config['file_cache_path']
  code <<-EOH
    #{installer} #{console_mode} #{install_dir} #{install_path} #{quiet_mode} \
    #{var_file} #{response_file}
  EOH
end
