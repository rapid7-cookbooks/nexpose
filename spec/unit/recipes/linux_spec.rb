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


require_relative '../../spec_helper'

describe 'nexpose::linux' do
  let(:install_bin) { 'NeXposeSetup-Linux64.test.bin' }
  let(:cache_path) { '/var/chef/cache' }
  let(:install_path) { '/opt/nexpose/test' }
  let(:dbase) { ::File.join(install_path, 'nsc/nxpgsql/nxpdata/postgresql.conf') }
  let(:installer) { ::File.join(cache_path, install_bin ) }
  let(:buffers) { '1MB' }
  let(:conns) { 5 }
  let(:mem) { '2MB' }
  let(:segments) { 2 }
  let(:cache_size) { '10MB' }
  let(:log_error) { 'debug' }
  let(:log_duration) { 0 }
  let(:wal) { '34KB' }
  let(:maintenance) { '12KB' }
  let(:engine) { false }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(file_cache_path: cache_path) do |node|
      node.set['nexpose']['installer']['bin'] = install_bin
      node.set['nexpose']['installer']['path'] = install_path
      node.set['nexpose']['engine'] = engine
      node.set['nexpose']['postgresql']['shared_buffers'] = buffers
      node.set['nexpose']['postgresql']['max_connections'] = conns
      node.set['nexpose']['postgresql']['work_mem'] = mem
      node.set['nexpose']['postgresql']['checkpoint_segments'] = segments
      node.set['nexpose']['postgresql']['effective_cache_size'] = cache_size
      node.set['nexpose']['postgresql']['log_min_error_statement'] = log_error
      node.set['nexpose']['postgresql']['log_min_duration_statement'] = log_duration
      node.set['nexpose']['postgresql']['wal_buffers'] = wal
      node.set['nexpose']['postgresql']['maintenance_work_mem'] = maintenance
    end.converge(described_recipe)
  end

  it 'downloads the nexpose linux installer with mode 0700' do
    expect(chef_run).to create_remote_file(installer).with(
                          mode: 0700
                        )
  end

  it 'installs nexpose and notifies init execute' do
    command = "#{installer} -q -dir #{install_path}"
    command << " -Dinstall4j.suppressUnattendedReboot=true"
    command << " -varfile #{cache_path}/response.varfile"

    expect(chef_run).to run_execute('install-nexpose').with(
                          user: 'root',
                          cwd: cache_path,
                          command: command,
                          creates: ::File.join(install_path, 'shared')
                        )

    resource = chef_run.execute('install-nexpose')
    expect(resource).to notify('execute[init]').to(:run).immediately
    expect(resource).to notify('service[nexpose]').to(:enable).immediately
  end

  it 'notifies the nexpose service to start if executed' do
    resource = chef_run.execute('init')
    expect(resource).to do_nothing
    expect(resource).to notify('service[nexpose]').to(:start).immediately
  end

  it 'renders the postgresql database configuration file and restarts nexpose' do
    resource = chef_run.template(dbase)
    expect(resource).to notify('service[nexpose]').to(:restart).delayed

    expect(chef_run).to create_template(dbase).with(
                          user: 'nxpgsql',
                          group: 'nxpgsql',
                          mode: 0600,
                          variables: {
                            :shared_buffers => buffers,
                            :max_connections => conns,
                            :work_mem => mem,
                            :checkpoint_segments => segments,
                            :effective_cache_size => cache_size,
                            :log_min_error_statement => log_error,
                            :log_min_duration_statement => log_duration,
                            :wal_buffers => wal,
                            :maintenance_work_mem => maintenance
                          }
                        )
    expect(chef_run).to render_file(dbase).with_content(/max_connections = #{conns}/)
    expect(chef_run).to render_file(dbase).with_content(/shared_buffers = #{buffers}/)
    expect(chef_run).to render_file(dbase).with_content(/work_mem = #{mem}/)
    expect(chef_run).to render_file(dbase).with_content(/checkpoint_segments = #{segments}/)
    expect(chef_run).to render_file(dbase).with_content(/effective_cache_size = #{cache_size}/)
    expect(chef_run).to render_file(dbase).with_content(/log_min_error_statement = #{log_error}/)
    expect(chef_run).to render_file(dbase).with_content(/log_min_duration_statement = #{log_duration}/)
    expect(chef_run).to render_file(dbase).with_content(/wal_buffers = #{wal}/)
    expect(chef_run).to render_file(dbase).with_content(/maintenance_work_mem = #{maintenance}/)
  end

  it 'does not update the database template and sets the proper init script if installing an engine' do
    chef_run.node.set['nexpose']['engine'] = true
    chef_run.converge(described_recipe)

    expect(chef_run).to_not create_template(dbase)

    service = chef_run.service('nexpose')
    expect(service.service_name).to eq('nexposeengine.rc')
    expect(service).to do_nothing
  end
end
