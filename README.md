## vagrant_kubernetes
With this repository, we can install kubernetes cluster via vagrant application, we just need to install below mentioned software before running evrything.
* vagrant for windows 10
* Latest oracle virtual box

## Download the Vagrant and VirtualBox software
Download the vagrant via below given link and download the required version accordingly.
https://www.vagrantup.com/downloads.html 

Download the virtual box from below given link.

https://www.virtualbox.org

## Discuss the attached file now.
we have vagrantfile and which is used to install the multiple machines in virtual box with the help of vagrant.
> we can use shell script as well during the installation of machine so that we can automate everything.
> We have used 1 script which is ``` bootstrap.sh ```which is used to install all required packages and prerequisites.
> ``` bootstrap_kmaster.sh ``` is used to install the kubeadm in master node only anf fetch the multiple details accordingly.
> ``` bootstrap_kworker.sh ``` is used to join the k8s cluster with worker node.

## Note: 
In the given file kube-flannel.yml, i have changed the interface details so that we can install the pod flannel network on eth1 interface becasue eth0 is reserved for NAT and also used by vagrant file as well.

## Lets verify the all machines one by one.
1) Firstly we need to clone this repository in any path from where we want to install the machines.
2) Open the ```git bash``` in the software and run the below command.
    ``` cd C:\Users\BVGV9953\CloudDrive\vagrant_machine\Office Machine
        vagrant up ```
    
3) Suppose all machines has been installed & now its time to verify all the machines one by one.
  ``` vagrant status ```
  ``` vagrant ssh kmaster ```
          ``` kubectl version ```
          ``` kubeadm version ```
          ``` systemctl status kubelet ```
          ``` cat /etc/hosts | grep -i example ```
          ``` systemctl status docker ```
          ``` docker ps ```                  
   

## Best of luck for the installation of kubernetes clusters via kubeadm. ###
