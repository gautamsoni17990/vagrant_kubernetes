#!/usr/bin/env bash

# Initialize Kubernetes
echo "[Task 1] Initialize kubernetes cluster"
kubeadm init --apiserver-advertise-address=172.28.128.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log &>2

# Copy kube admin config
echo "[Task 2] Copy kube admin config to vagrant user in .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
echo "[Task 3] Deploy flannel pod network"
su - vagrant -c "kubectl create -f https://raw.githubusercontent.com/gautamsoni17990/kubernetes/master/vagrant-provisioning/kube-flannel.yaml" &>2

# Generate Cluster Join Command
echo "[Task 4] Generate and Save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh