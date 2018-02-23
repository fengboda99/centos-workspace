sudo yum install -y epel-release
sudo yum install -y lrzsz python-devel python-pip gcc git tmux java-1.8.0-openjdk the_silver_searcher htop
sudo pip install -U pip -i http://mirrors.aliyun.com/pypi/simple --trusted-host=mirrors.aliyun.com
sudo pip install ansible virtualenv -i http://mirrors.aliyun.com/pypi/simple --trusted-host=mirrors.aliyun.com

echo "DNS1=8.8.8.8" | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-enp0s3
mkdir -p /home/vagrant/github
ANSIBLE_UTIL='/home/vagrant/github/ansible-playground'

if [ ! -d "$ANSIBLE_UTIL" ]; then
    git clone https://github.com/harrifeng/ansible-playground.git ${ANSIBLE_UTIL}
fi

declare -a arr=(00-install-common 03-install-docker-on-centos 04-install-new-git-on-centos \
                                  05-install-new-emacs-on-centos \
                                  06-install-supervisord-and-configure-systemd-on-centos \
                                  07-install-nodejs-on-centos \
                                  08-install-python3-on-centos \
                                  10-install-shellcheck-on-centos \
                                  12-install-golang-1-9-on-centos)

for dir in "${arr[@]}"
do
  ansible-playbook -i ${ANSIBLE_UTIL}/etc_ansible_hosts ${ANSIBLE_UTIL}/${dir}/main.yml --extra-vars "variable_host=localhost ansible_become_pass=vagrant"
done

chown -R vagrant:vagrant /home/vagrant/github

UTIL_BINARY='/home/vagrant/github/binary'

if [ ! -d "$UTIL_BINARY" ]; then
    git clone https://github.com/harrifeng/binary.git ${UTIL_BINARY}
fi
ln -sf /home/vagrant/.cow /home/vagrant/github/binary/amd64/dot-cow


echo "
[Unit]
Description=Cow Proxy Daemon

[Service]
User=vagrant
Group=vagrant
RuntimeDirectory=cow
Type=simple
ExecStart=/home/vagrant/.cow/cow
Restart=on-failure
RestartSec=10s
" | sudo tee /usr/lib/systemd/system/cow.service
sudo systemctl daemon-reload
sudo systemctl enable cow.service
sudo systemctl start cow.service
echo "<----------finishing provision--------------->"
