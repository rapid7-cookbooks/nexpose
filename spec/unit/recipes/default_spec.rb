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

require_relative '../../spec_helper'

describe 'nexpose::default' do
  let(:chef_cache) { '/tmp/chef/cache' }
  let(:varfile) { ::File.join(chef_cache, 'response.varfile') }
  let(:installer_path) { '/opt/nexpose/test' }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(file_cache_path: chef_cache) do |node|
      node.set['nexpose']['first_name'] = 'foo'
      node.set['nexpose']['last_name'] = 'bar'
      node.set['nexpose']['company_name'] = 'Parts Unlimited'
      node.set['nexpose']['username'] = 'fbar'
      node.set['nexpose']['password'] = 'password123!'
      node.set['nexpose']['component_type'] = 'typical'
      node.set['nexpose']['installer']['path'] = installer_path
    end.converge(described_recipe)
  end

  it 'Renders the varfile from a template' do
    expect(chef_run).to render_file(varfile).with_content(/^firstname=foo$/)
    expect(chef_run).to render_file(varfile).with_content(/^lastname=bar$/)
    expect(chef_run).to render_file(varfile).with_content(/^company=Parts Unlimited$/)
    expect(chef_run).to render_file(varfile).with_content(/^username=fbar$/)
    expect(chef_run).to render_file(varfile).with_content(/^password1=password123!$/)
    expect(chef_run).to render_file(varfile).with_content(/^password2=password123!$/)
  end

  it 'does not add proxy settings to the varfile if they are disabled.' do
    expect(chef_run).to render_file(varfile).with_content(/^((?!proxyHost=.*))/)
    expect(chef_run).to render_file(varfile).with_content(/^((?!proxyPort=.*))/)
  end

  it 'configures the installer varfile to install nexpose as a console and not a standalone engine' do
    expect(chef_run).to render_file(varfile).with_content(/^sys\.component\.engine\$Boolean=false$/)
    expect(chef_run).to render_file(varfile).with_content(/^sys\.component\.typical\$Boolean=true$/)
    expect(chef_run).to render_file(varfile).with_content(/^((?!component=engine$))/)
  end

  it 'configures the installer varfile to install nexpose as a standalone engine' do
    chef_run.node.set['nexpose']['engine'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file(varfile).with_content(/^sys\.component\.engine\$Boolean=true$/)
    expect(chef_run).to render_file(varfile).with_content(/^sys\.component\.typical\$Boolean=false$/)
  end

  it 'includes the linux recipe when a linux platform is detected.' do
    expect(chef_run).to include_recipe('nexpose::linux')
    expect(chef_run).not_to include_recipe('nexpose::windows')
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
      end.converge(described_recipe)
    end

    it 'includes the linux recipe' do
      expect(chef_run).to include_recipe('nexpose::linux')
    end
  end
end
