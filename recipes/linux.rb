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

# Get Nexpose Installer
remote_file File.join(Chef::Config['file_cache_path'], node['nexpose']['installer']['bin']) do
  source node['nexpose']['installer']['uri']
  mode 0700
end

# Install Nexpose
bash "install-nexpose" do
  user "root"
  cwd Chef::Config['file_cache_path']
  code <<-EOH
    #{node['nexpose']['installer']['bin'].to_s} #{node['nexpose']['install_args'].join(' ')}
  EOH
  not_if { ::Dir.exists?(node['nexpose']['install_path']) }
end
