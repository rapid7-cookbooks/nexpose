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

case node['nexpose']['component_type']
when 'typical', 'console'
  engine = false
  console = true
when 'engine'
  engine =true
  console = false
else
  Chef::Application.fatal!("Unsupported installation type: " + node['nexpose']['component'])
end

# Configure template response.varfile
template ::File.join(Chef::Config['file_cache_path'], 'response.varfile') do
  source 'response.varfile.erb'
  variables ({ :engine_bool => engine.to_s,
               :console_bool => console.to_s })
  mode 0644
end

case node['os']
when 'linux'
  include_recipe 'nexpose::linux'
when 'windows'
  include_recipe 'nexpose::windows'
else
  Chef::Application.fatal!("Unsupported operating system: " + node['os'])
end

