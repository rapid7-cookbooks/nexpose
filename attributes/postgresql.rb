#
# Cookbook Name:: nexpose
# Attributes:: postgresql
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

default['nexpose']['postgresql']['shared_buffers'] = '128MB'
default['nexpose']['postgresql']['max_connections'] = 100
default['nexpose']['postgresql']['work_mem'] = '4MB'
default['nexpose']['postgresql']['checkpoint_segments'] = 3
default['nexpose']['postgresql']['effective_cache_size'] = '128MB'
default['nexpose']['postgresql']['log_min_error_statement'] = 'error'
default['nexpose']['postgresql']['log_min_duration_statement'] = -1
default['nexpose']['postgresql']['wal_buffers'] = -1
default['nexpose']['postgresql']['maintenance_work_mem'] = '16MB'
