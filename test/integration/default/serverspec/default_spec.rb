require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

  describe 'nexpose::default' do
    it 'installed the screen package' do
      expect(package('screen')).to be_installed
  end
  describe file('/opt/rapid7/nexpose') do
    it { should be_directory }
  end
  describe service ('nexposeconsole.rc') do
    it { should be_running }
  end
end
