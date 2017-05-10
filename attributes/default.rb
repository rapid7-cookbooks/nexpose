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

# Trailing space has been added to the package_name due to a bug in the installer.
# Without this space the installation on Windows is not idempotent as the
# DisplayName value will not match. This bug will be resolved in future versions
# of the Nexpose installer.
default['rapid7']['product'] = 'Nexpose '
# Nexpose Installer
default['nexpose']['installer']['linux']['bin'] = 'Rapid7Setup-Linux64.bin'
default['nexpose']['installer']['linux']['checksum'] = nil
default['nexpose']['installer']['windows']['bin'] = 'Rapid7Setup-Windows64.exe'
default['nexpose']['installer']['windows']['checksum'] = nil
# Set the bin URL based on the detected OS value. Supported values are Linux and Windows.
default['nexpose']['installer']['bin'] = node['nexpose']['installer'][node['os']]['bin']
default['nexpose']['installer']['uri'] = "http://download2.rapid7.com/download/InsightVM/#{node['nexpose']['installer']['bin']}"


default['nexpose']['install_path']['linux'] = ::File.join('/', 'opt', 'rapid7', node['rapid7']['product'].downcase.rstrip)
default['nexpose']['install_path']['windows'] = "\"#{::File.join('C:', 'Program Files', 'Rapid7', node['rapid7']['product'])}\""
default['nexpose']['service_action'] = [:enable, :start]

# response.varfile template default values
# Registration information
default['nexpose']['first_name'] = 'Nexpose'
default['nexpose']['last_name'] = 'User'
default['nexpose']['company_name'] = 'Rapid7'
# Install type (typical || engine)
default['nexpose']['component_type'] = 'typical'
# Communication direction (0 => Engine->Console || 1 => Console->Engine)
default['nexpose']['communication_direction'] = 1
# Credentials
default['nexpose']['username'] = 'nxadmin'
default['nexpose']['password'] = 'nxadmin'
default['nexpose']['require_password_change'] = false
# Shortcuts and Start Menu configs
default['nexpose']['create_desktop_icon'] = true
default['nexpose']['shortcuts_for_all_users'] = true
default['nexpose']['startmenu_item_name'] = node['rapid7']['product']
default['nexpose']['suppress_reboot'] = true
default['nexpose']['proxy_host'] = false
default['nexpose']['proxy_port'] = false

# Installation options
default['nexpose']['install_args'] = ['-q',
                                      '-dir', node['nexpose']['install_path'][node['os']].to_s,
                                      '-Dinstall4j.suppressUnattendedReboot=' + node['nexpose']['suppress_reboot'].to_s,
                                      '-varfile', ::File.join(Chef::Config['file_cache_path'], 'response.varfile')]
default['nexpose']['custom_properties'] = {}
