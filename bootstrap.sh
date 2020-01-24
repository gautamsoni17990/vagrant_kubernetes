#!/usr/bin/env bash
# Update Host file 
echo "[Task 1] Update /etc/hosts file"
cat >> /etc/hosts<<EOF
172.28.128.100 kmaster.example.com kmaster
172.28.128.101 kworker1.example.com kworker1
172.28.128.102 kworker2.example.com kworker2
EOF

# Remove the firewalld package from the server
echo "[Task 2] Stop and disable firewalld"
sudo systemctl disable firewalld &>2
sudo systemctl stop firewalld

# Install the new package ebtables
echo "[Task 3] Install required packages"
sudo yum -y install wget telnet elinks net-tools ebtables vim lvm2 device-mapper-persistent-data dnf* &>2


# Enable the sysctl settings
echo "[Task 4] Add sysctl settings"
cat >> /etc/sysctl.d/k8s.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system &>2

# Install the docker container into your machine.
echo "[Task 5] Enable & Install the docker repo"
sudo dnf config-manager \
	--add-repo \
	https://download.docker.com/linux/centos/docker-ce.repo &>2
sudo dnf install docker-ce -y &>2

# Enable and start the docker service now.
echo "[Task 6] Start and Enable the docker service"
systemctl enable docker &>2
systemctl start docker

# Disable the selinux
echo "[Task 7] Disable SELINUX"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/sysconfig/selinux

# Disable the swap memory in the machine
echo "[Task 8] Disable the swap memory"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Enable the ssh Authentication
echo "[Task 9] Enable the ssh Authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl reload sshd

# Install the kubeadm, kubelet and kubectl into the machine.
echo "[Task 10] Install the kubernetes components and enable the Repo"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg 
		https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

EOF

# Install the kubernetes
echo "[Task 11] Install and enable the kubelet service"
yum install -y kubelet kubeadm kubectl &>2

# Enable and start the kubelet
echo "[Task 12] Enable the k8s service"
systemctl enable kubelet &>2
systemctl start kubelet &>2

# Lets provide the proper permission to vagrant user.
echo "[Task 13] Provide the exact permission to vagrant user"
usermod -G vagrant,docker vagrant

# Lets Create the bashrc environment for vagrant user.
echo "[Task 14] Enable the Aliases"
cat >> /home/vagrant/.bashrc<<EOF
alias kga='kubectl get all'
alias kgn='kubectl get nodes -o wide'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgs='kubectl get services'
alias k='kubectl'
source <(kubectl completion bash)
export TERM=xterm
EOF