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
node.default['nexpose']['installer']['bin'] = 'NeXposeSetup-Linux64.bin'
node.default['nexpose']['installer']['uri'] = "http://download2.rapid7.com/download/NeXpose-v4/#{node['nexpose']['installer']['bin']}"

# Installation options
node.default['nexpose']['console_mode'] = '-console'
node.default['nexpose']['install_dir'] = '-dir'
node.default['nexpose']['quiet_mode'] = '-q'
node.default['nexpose']['var_file'] = '-varfile'

# Install path
node.default['nexpose']['install_path'] = '/opt/rapid7/nexpose'

# response.varfile template default values
# Registration information
node.default['nexpose']['first_name'] = 'Nexpose'
node.default['nexpose']['last_name'] = 'Dev'
node.default['nexpose']['company_name'] = 'Rapid7'
# Install type (typical || engine)
node.default['nexpose']['component_type'] = 'typical'
# Credentials
node.default['nexpose']['username'] = 'nxadmin'
node.default['nexpose']['password'] = 'nxadmin'
# Shortcuts and Start Menu configs
node.default['nexpose']['create_desktop_icon'] = 'true'
node.default['nexpose']['shortcuts_for_all_users'] = 'true'
node.default['nexpose']['startmenu_item_name'] = 'Nexpose'


