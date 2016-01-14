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

Test Kitchen Verified:
* Ubuntu 12.04
* Ubuntu 14.04
* Centos 7.1

The cookbook currently has also been tested on Windows Server 2012


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
    <td><tt>['nexpose']['installer']'['bin']</tt></td>
    <td>String</td>
    <td>File name of the Nexpose installer. This is one is used by both Linux and Windows cookbooks.</td>
    <td>
      <ul>
        <li>Linux: NeXposeSetup-Linux64.bin</li>
        <li>Windows: NeXposeSetup-Windows64.exe</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td><tt>['nexpose']['installer']['path']</tt></td>
    <td>String</td>
    <td>Path to install Nexpose.</td>
    <td>
      <ul>
        <li>Linux: /opt/rapid7/nexpose</li>
        <li>Windows: C:\Program Files\Rapid7\Nexpose</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td><tt>['nexpose']['installer']['uri']</tt></td>
    <td>String</td>
    <td>Remote path to the Nexpose installer.</td>
    <td><tt>http://download2.rapid7.com/download/NeXpose-v4/</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['installer']['checksum']</tt></td>
    <td>String</td>
    <td>Checksum of the installer file.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['engine']</tt></td>
    <td>Boolean</td>
    <td>Enable the Nexpose Engine instead of the Console</td>
    <td><tt>false</tt></td>
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
    <td><tt>['nexpose']['create_desktop_icon']</tt></td>
    <td>boolean</td>
    <td>Windows Only: Create Desktop Icon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['shortcuts_for_all_users']</tt></td>
    <td>boolean</td>
    <td>Windows Only: Install the desktop shortcut for all Users</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['startmenu_item_name']</tt></td>
    <td>String</td>
    <td>Windows Only: Start menu name for Nexpose</td>
    <td><tt>Nexpose </tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['suppress_reboot']</tt></td>
    <td>Boolean</td>
    <td>Windows Only: Prevent the Nexpose installer from starting the Nexpose service</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['proxy_host']</tt></td>
    <td>String</td>
    <td>HTTP Proxy Host</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['proxy_port']</tt></td>
    <td>Integer</td>
    <td>HTTP Proxy Host</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['install_args']</tt></td>
    <td>Array</td>
    <td>Array of arguments passed to the installer.</td>
    <td>
      <ul>
        <li>'-q'</li>
        <li>'-dir'</li>
        <li>node['nexpose']['installer']['path']</li>
        <li>'-Dinstall4j.suppressUnattendedReboot=#{node['nexpose']['suppress_reboot']}</li>
        <li>'-varfile'</li>
        <li>File.join(Chef::Config['file_cache_path']</li>
        <li>'response.varfile'</li>
      <ul>
     </td>
  </tr>
</table>

#### nexpose::database
These attributes are used to tune the PostgreSQL database shipped with
Nexpose. Each attribute is covered in the Nexpose admin guide. Please
see the PostgreSQL documentation for detailed information on each setting.
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['shared_buffers']</tt></td>
    <td>String</td>
    <td><tt>128MB</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['max_connections']</tt></td>
    <td>Integer</td>
    <td><tt>100</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['work_mem']</tt></td>
    <td>String</td>
    <td><tt>4MB</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['checkpoint_segments']</tt></td>
    <td>Integer</td>
    <td><tt>3</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['effective_cache_size']</tt></td>
    <td>String</td>
    <td><tt>128MB</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['log_min_error_statement']</tt></td>
    <td>String</td>
    <td><tt>error</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['log_min_duration_statement']</tt></td>
    <td>Integer</td>
    <td><tt>-1</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['wal_buffers']</tt></td>
    <td>Integer</td>
    <td><tt>-1</tt></td>
  </tr>
  <tr>
    <td><tt>['nexpose']['postgresql']['maintenance_work_mem']</tt></td>
    <td>String</td>
    <td><tt>16MB</tt></td>
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

Testing
-------
This cookbook has 2 test suites:

* Console: Configures the Nexpose Console and forwards port 3780
* Engine: Configures the Nexpose Engine and forwards port 40814

The tests are complete with integration tests using the new Inspec
testing framework from Chef. Please install the latest Inspec gem
prior to running the integration tests. Inspec is a very active project
and the gem that shipped with ChefDK at the time these tests were
written, did not work properly.

To update the inspec gem for the ChefDk execute the following command:
```bash
chef exec gem update inspec
```

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
- Author:: Nick Downs (<nickryand@gmail.com>)

```text
Copyright 2013-2014, Rapid7, LLC.
Copyright 2015, Nick Downs

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
