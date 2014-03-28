#
# Cookbook Name:: nexpose
# Attributes:: default
#
# Author:: Kevin Gathorpe (<kevin_gawthorpe@rapid7.com>)
# Author:: Ryan Hass (<ryan_hass@rapid7.com>)
#
# Copyright 2013-2014, Rapid7, LLC
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

# Nexpose Installer
default['nexpose']['installer']['linux']['bin'] = 'NeXposeSetup-Linux64.bin'
default['nexpose']['installer']['windows']['bin'] = 'NeXposeSetup-Windows64.exe'
default['nexpose']['installer']['bin'] = node['nexpose']['installer'][node['os']]['bin']
default['nexpose']['installer']['uri'] = "http://download2.rapid7.com/download/NeXpose-v4/#{node['nexpose']['installer']['bin']}"
default['nexpose']['response_file']

# Install path
case node['os']
when 'linux'
  default['nexpose']['install_path'] = '/opt/rapid7/nexpose'
when 'windows'
  default['nexpose']['install_path'] = 'C:\Program Files\Rapid7\nexpose'
end



# response.varfile template default values
# Registration information
default['nexpose']['first_name'] = 'Nexpose'
default['nexpose']['last_name'] = 'Dev'
default['nexpose']['company_name'] = 'Rapid7'
# Install type (typical || engine)
default['nexpose']['component_type'] = 'typical'
# Credentials
default['nexpose']['username'] = 'nxadmin'
default['nexpose']['password'] = 'nxadmin'
# Shortcuts and Start Menu configs
default['nexpose']['create_desktop_icon'] = 'true'
default['nexpose']['shortcuts_for_all_users'] = 'true'
default['nexpose']['startmenu_item_name'] = 'Nexpose'

# Installation options
default['nexpose']['install_args'] = ['-q',
                                      '-dir', "#{node['nexpose']['install_path']}",
                                      '-varfile', "#{File.join(Chef::Config['file_cache_path'], 'response.varfile')}"]
