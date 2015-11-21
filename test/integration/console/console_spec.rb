# Integration tests to confirm proper Nexpose installation
# and execution.

# This should be a processes test however the processes
# API is not stable yet
describe command('ps aux | grep nexserv') do
  its('exit_status') { should eq 0 }
end

describe user('nxpgsql') do
  it { should exist }
  its('group') { should eq 'nxpgsql' }
end

describe file('/opt/rapid7/nexpose/nsc/nxpgsql/nxpdata/postgresql.conf') do
  it { should be_owned_by 'nxpgsql' }
  it { should be_grouped_into 'nxpgsql' }
  its('mode') { should eq 0600 }
  its('content') { should match 'max_connections = 100' }
  its('content') { should match 'shared_buffers = 128MB' }
  its('content') { should match 'work_mem = 4MB' }
  its('content') { should match 'checkpoint_segments = 3' }
  its('content') { should match 'effective_cache_size = 128MB' }
  its('content') { should match 'log_min_error_statement = error' }
  its('content') { should match 'log_min_duration_statement = -1' }
  its('content') { should match 'wal_buffers = -1' }
  its('content') { should match 'maintenance_work_mem = 16MB' }
end

for i in 0..300
  if port(3780).listening?
    break
  end
  sleep 2
end

describe port(3780) do
  it { should be_listening }
  its('protocols') { should eq ['tcp6'] }
end
