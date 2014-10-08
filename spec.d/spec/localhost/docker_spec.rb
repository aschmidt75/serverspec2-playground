require 'spec_helper'

describe docker_image('busybox:latest') do
  it { should be_present }

  it { should_not have_setting('Architecture','i386') }
  its(:Architecture) { should eq 'amd64' }
end

# docker run -tdi --name "c1" busybox
describe docker_container('c1') do
  it { should be_present }
  it { should be_running }

  its(:HostConfig_NetworkMode) { should eq 'bridge' }
  its(:Path) { should eq '/bin/sh' }
end

# docker run -tdi --name "c2" -v /data:/tmp busybox
describe docker_container('c2') do
  it { should be_running }
  it { should have_volume('/tmp','/data') }
end
