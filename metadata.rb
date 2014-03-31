name             'nexpose'
maintainer       'Rapid7, LLC'
maintainer_email 'kevin_gawthorpe@rapid7.com'
license          'Apache 2.0'
description      'Installs/Configures Nexpose'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

%w( debian ubuntu redhat windows ).each do |os|
  supports os
end

depends 'windows'
