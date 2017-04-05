Nexpose Cookbook
==========
[![Build Status](https://travis-ci.org/rapid7-cookbooks/nexpose.svg)](https://travis-ci.org/rapid7-cookbooks/nexpose)
[![Cookbook Version](https://img.shields.io/cookbook/v/nexpose.svg)](https://supermarket.chef.io/cookbooks/nexpose)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

This cookbook installs a Nexpose console or engine.

Requirements
------------

Platforms:

* Debian, Ubuntu, RedHat, Windows

The cookbook currently has only been tested on Ubuntu 12.04 and Windows Server 2012

Attributes
----------

#### nexpose::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nexpose']['installer']['linux']['bin']</tt></td>
    <td>String</td>
    <td>File name of the Nexpose installer for Linux.</tt></td>
    <td><tt>Rapid7Setup-Linux64.bin</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['installer']['windows']['bin']</tt></td>
    <td>String</td>
    <td>File name of the Nexpose installer for Windows.</tt></td>
    <td><tt>Rapid7Setup-Windows64.exe</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['installer']'['bin']</tt></td>
    <td>String</td>
    <td>File name of the Nexpose installer. This is one is used by both Linux and Windows cookbooks.</td>
    <td><tt>node['nexpose']['installer'][node['os']]['bin']</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['installer']['uri']</tt></td>
    <td>String</td>
    <td>Remote path to the Nexpose installer.</td>
    <td><tt>http://download2.rapid7.com/download/NeXpose-v4/#{node['nexpose']['installer']['bin']}</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['install_path']['linux']</tt></td>
    <td>String</td>
    <td>Path to install Nexpose.</td>
    <td><tt>/opt/rapid7/nexpose</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['install_path']['windows']</tt></td>
    <td>String</td>
    <td>Path to install Nexpose.</td>
    <td><tt>C:\Program Files\Rapid7\Nexpose</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['service_action']</tt></td>
    <td>Array</td>
    <td>Default actions to use for the service resource.</td>
    <td><tt>[:enable, :start]</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['first_name']</tt></td>
    <td>String</td>
    <td>First name of registered product/license owner.</td>
    <td><tt>Nexpose</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['last_name']</tt></td>
    <td>String</td>
    <td>Last name of registered product/license owner.</td>
    <td><tt>Dev</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['company_name']</tt></td>
    <td>String</td>
    <td>Company name of registered product/license owner.</td>
    <td><tt>Rapid7</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['username']</tt></td>
    <td>String</td>
    <td>Global Administrator Username</td>
    <td><tt>nxadmin</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['password']</tt></td>
    <td>String</td>
    <td>Global Administrator Password</td>
    <td><tt>nxadmin</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['require_password_change']</tt></td>
    <td>Boolean</td>
    <td>If true, requires user to change their password from nxadmin upon first login</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['install_args']</tt></td>
    <td>Array</td>
    <td>Array of arguments passed to the installer.<tt>
    <td><tt>['-q', '-dir', node['nexpose']['install_path'][node[os]], '-Dinstall4j.suppressUnattendedReboot=' + node['nexpose']['suppress_reboot'].to_s, '-varfile', File.join(Chef::Config['file_cache_path'], 'response.varfile')]</td></tt>
  </tr>
  <tr>
    <td><tt>['nexpose']['custom_properties']</tt></td>
    <td>Hash</td>
    <td>Hash of key value pairs to be written to <install_path>/{nsc,nse}/CustomEnvironment.properties<tt>
    <td><tt>{}</tt></td>
  </tr>
</table>

Usage
-----
#### nexpose::default
Just include `nexpose` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nexpose]"
  ]
}
```

To-Do
-----
- This cookbook needs chefspec and test-kitchen tests.

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

- Author:: Kevin Gawthope (<kevin_gawthopre@rapid7.com>)
- Author:: Ryan Hass (<ryan_hass@rapid7.com>)

Copyright 2013-2014, Rapid7, LLC.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
