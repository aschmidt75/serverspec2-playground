# -*- mode: ruby -*-
# vi: set ft=ruby :
#

Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.define "serverspec2-playground", primary: true do |s|
    s.vm.synced_folder "spec.d/", "/mnt/spec.d"

    # install & run serverspec
    s.vm.provision 'shell', inline: <<EOS
	sudo apt-get update -yqq
	sudo apt-get -yqq install git
	sudo gem install bundler
EOS

    s.vm.provision 'shell', privileged: false, inline: <<EOS
	cd /home/vagrant
	[[ ! -d serverspec2 ]] && mkdir serverspec2
	cd serverspec2

	[[ ! -d specinfra ]] && git clone https://github.com/aschmidt75/specinfra
	cd specinfra
	git pull --rebase
	git fetch --tags
	git checkout integrate_docker_resource_type
	bundle
	touch integration-test/wercker.yml
	bundle exec rake build
	sudo gem install --local pkg/$( ls -tr1 pkg | tail -1)
	cd ..

	[[ ! -d serverspec ]] && git clone https://github.com/aschmidt75/serverspec
	cd serverspec
	git pull --rebase
	git fetch --tags
	git checkout integrate_docker_resource_type
	bundle
	touch integration-test/wercker.yml
	bundle exec rake build
	sudo gem install --local pkg/$( ls -tr1 pkg | tail -1)
	cd ..

EOS

    s.vm.provision 'shell', inline: <<EOS
[ -e /usr/lib/apt/methods/https ] || {
  apt-get update
  apt-get install apt-transport-https
}
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get -yqq install lxc-docker
sudo usermod -G docker vagrant
EOS

    # install nsenter
    # from: https://blog.codecentric.de/2014/07/vier-wege-in-den-docker-container/
    s.vm.provision 'shell', inline: <<EOS
if [[ -z `which nsenter` ]]; then
        TMPDIR=`mktemp -d` && {
                cd $TMPDIR
                curl --silent https://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-2.24.tar.gz | tar -zxf-
                cd util-linux-2.24
                ./configure --without-ncurses
                make nsenter
                sudo cp nsenter /usr/local/bin
                rm -fr $TMPDIR
        }
fi
EOS

    # create some sample playground, so that demo steps will run
    s.vm.provision 'shell', inline: <<EOS
docker pull busybox:latest
docker run -tdi --name "c1" busybox
docker run -tdi --name "c2" -v /data:/tmp busybox
EOS

  end
  
end
