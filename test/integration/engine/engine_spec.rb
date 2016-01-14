# Integration tests to confirm proper Nexpose installation
# and execution.

# TODO: Port to process() check once API stablizes
describe command('ps aux | grep nexserv') do
  its('exit_status') { should eq 0 }
end

describe user('nxpgsql') do
  it { should exist }
  its('group') { should eq 'nxpgsql' }
end

# The process name on centos/rhel is truncated to just a '.'
case os[:family]
when 'centos'
  process = '.'
else
  process = 'nseserv'
end

# Nexpose Engine takes a couple of minutes to initialize so we are
# going to wait 10 minutes for the port to begin listening.
for i in 0..300
  if port(40814).listening?
    break
  end
  sleep 2
end

describe port(40814) do
  it { should be_listening }
  its('protocols') { should eq ['tcp6'] }
  its('processes') { should eq [process] }
end
