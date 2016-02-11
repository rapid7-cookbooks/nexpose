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

  context 'consoles or engines' do
    let(:chef_run) do 
      ChefSpec::SoloRunner.new do |node|
        node.set['nexpose']['installer']['linux']['bin'] = 'fakefile'
      end.converge(described_recipe)
    end

    it 'downloads the nexpose linux installer with mode 0700' do
      expect(chef_run).to create_remote_file(
        ::File.join(Chef::Config['file_cache_path'],
                    chef_run.node['nexpose']['installer']['bin'])
      ).with(mode: 0700)
    end

    it 'installs nexpose' do
      expect(chef_run).to run_execute('install-nexpose').with_user('root')
      expect(chef_run).to run_execute('install-nexpose').with(
        command: "#{File.join(Chef::Config['file_cache_path'],
                    chef_run.node['nexpose']['installer']['bin'])} -q -dir /opt/rapid7/nexpose -Dinstall4j.suppressUnattendedReboot=true -varfile #{Chef::Config['file_cache_path']}/response.varfile")
    end


    # This test finds bugs, but currently breaks when things are working properly.
    # Disabled until I have more time to fix this issue.
    xit 'does not install nexpose if it already is installed' do
      allow(::File).to receive(:exists?).with('/opt/rapid7/nexpose/shared').and_return(true)
      expect(chef_run).to run_execute('install-nexpose').with(not_if: true)
    end
  end

  context 'only consoles' do
    let(:chef_run) do 
      ChefSpec::SoloRunner.new do |node|
        node.set['nexpose']['component_type'] = 'typical'
      end.converge(described_recipe)
    end

    it 'replace the console init script' do
      expect(chef_run).to create_template('/etc/init.d/nexposeconsole.rc').with(mode: 0755)
      expect(chef_run).not_to create_template('/etc/init.d/nexposeengine.rc').with(mode: 0755)
    end

    it 'renders console specific values in the init script' do
      expect(chef_run).to render_file('/etc/init.d/nexposeconsole.rc').with_content(/nsc/)
      expect(chef_run).not_to render_file('/etc/init.d/nexposeconsole.rc').with_content(/nse/)
      expect(chef_run).to render_file('/etc/init.d/nexposeconsole.rc').with_content(/^NEX_TYPE=console$/)
      expect(chef_run).not_to render_file('/etc/init.d/nexposeconsole.rc').with_content(/^NEX_TYPE=engine$/)
      expect(chef_run).to render_file('/etc/init.d/nexposeconsole.rc').with_content(/nexserv/)
      expect(chef_run).not_to render_file('/etc/init.d/nexposeconsole.rc').with_content(/nseserv/)
    end

    it 'enable the nexpose console service' do
      expect(chef_run).to enable_service('nexposeconsole.rc').with(
        supports: { :status => true, :restart => true }
      )
      expect(chef_run).not_to enable_service('nexposeengine.rc')
    end

    it 'start the nexpose console service' do
      expect(chef_run).to start_service('nexposeconsole.rc')
      expect(chef_run).not_to start_service('nexposeengine.rc')
    end
  end

  context 'only engines' do
    let(:chef_run) do 
      ChefSpec::SoloRunner.new do |node|
        node.set['nexpose']['component_type'] = 'engine'
        node.set['nexpose']['service_action'] = [:enable, :start]
      end.converge(described_recipe)
    end

    it 'replace the engine init script' do
      expect(chef_run).to create_template('/etc/init.d/nexposeengine.rc').with(mode: 0755)
      expect(chef_run).not_to create_template('/etc/init.d/nexposeconsole.rc').with(mode: 0755)
    end

    it 'renders engine specific values in the init script' do
      expect(chef_run).to render_file('/etc/init.d/nexposeengine.rc').with_content(/nse/)
      expect(chef_run).not_to render_file('/etc/init.d/nexposeengine.rc').with_content(/nsc/)
      expect(chef_run).to render_file('/etc/init.d/nexposeengine.rc').with_content(/^NEX_TYPE=engine$/)
      expect(chef_run).not_to render_file('/etc/init.d/nexposeengine.rc').with_content(/^NEX_TYPE=console$/)
      expect(chef_run).to render_file('/etc/init.d/nexposeengine.rc').with_content(/nseserv/)
      expect(chef_run).not_to render_file('/etc/init.d/nexposeengine.rc').with_content(/nexserv/)
    end

    it 'enable the nexpose engine service' do
      expect(chef_run).to enable_service('nexposeengine.rc').with(
        supports: { :status => true, :restart => true }
      )
      expect(chef_run).not_to enable_service('nexposeconsole.rc')
    end

    it 'start the nexpose engine service' do
      expect(chef_run).to start_service('nexposeengine.rc')
      expect(chef_run).not_to start_service('nexposeconsole.rc')
    end
  end
end
