#
# Cookbook Name:: nexpose
# Attributes:: default
#
# Author:: Kevin Gathorpe (<kevin_gawthorpe@rapid7.com>)
# Author:: Ryan Hass (<ryan_hass@rapid7.com>)
# Author:: Nick Downs(<nickryand@gmail.com)
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

# Set the bin URL based on the detected OS value. Supported values are Linux and Windows.
case node['platform_family']
when 'windows'
  default['nexpose']['installer']['bin'] = 'NeXposeSetup-Windows64.exe'
  default['nexpose']['installer']['path'] = 'C:\Program Files\Rapid7\Nexpose'
when 'ubuntu', 'rhel', 'debian'
  default['nexpose']['installer']['bin'] = 'NeXposeSetup-Linux64.bin'
  default['nexpose']['installer']['path'] = '/opt/rapid7/nexpose'
end
default['nexpose']['installer']['checksum'] = nil
default['nexpose']['installer']['uri'] = "http://download2.rapid7.com/download/NeXpose-v4/"

# response.varfile template default values
# Registration information
default['nexpose']['first_name'] = 'Nexpose'
default['nexpose']['last_name'] = 'User'
default['nexpose']['company_name'] = 'Rapid7'

# Enable Engine installation only
default['nexpose']['engine'] = false

# Credentials
default['nexpose']['username'] = 'nxadmin'
default['nexpose']['password'] = 'nxadmin'

# Shortcuts and Start Menu configs
default['nexpose']['create_desktop_icon'] = true
default['nexpose']['shortcuts_for_all_users'] = true
default['nexpose']['startmenu_item_name'] = 'Nexpose '
default['nexpose']['suppress_reboot'] = true
default['nexpose']['proxy_host'] = nil
default['nexpose']['proxy_port'] = nil

# Installation options
default['nexpose']['install_args'] = ['-q',
                                      '-dir', node['nexpose']['installer']['path'],
                                      "-Dinstall4j.suppressUnattendedReboot=#{node['nexpose']['suppress_reboot'].to_s}",
                                      '-varfile', ::File.join(Chef::Config['file_cache_path'], 'response.varfile')]
