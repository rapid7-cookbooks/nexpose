#
# Cookbook Name:: nexpose
# Recipe:: windows
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

log "Running #{node['rapid7']['product']} installer with Arguments: #{node['nexpose']['install_args'].join(' ')}" do
  level :info
  subscribes :install, "windows_package #{node['rapid7']['product']}", :immediately
end

windows_package node['rapid7']['product'] do
  source node['nexpose']['installer']['uri']
  checksum node['nexpose']['installer']['windows']['checksum']
  installer_type :custom
  options node['nexpose']['install_args'].join(' ')
  action :install
end
