## Vagrant_kubernetes
With this repository, we can install kubernetes cluster via vagrant application, we just need to install below mentioned software before running evrything.
* vagrant for windows 10
* Latest oracle virtual box

## Download the Vagrant and VirtualBox software
Download the vagrant via below given link and download the required version accordingly.
https://www.vagrantup.com/downloads.html 

Download the virtual box from below given link.

https://www.virtualbox.org

## Discuss the attached file now.
```
Vagrantfile
which is used to install the multiple machines in virtual box with the help of vagrant.
```
we can use shell script as well during the installation of machine so that we can automate everything.
```
bootstrap.sh
This is used to install all required packages and prerequisites.
```
``` 
bootstrap_kmaster.sh 
This is used to install the kubeadm in master node only anf fetch the multiple details accordingly.
``` 
``` 
bootstrap_kworker.sh
This is used to join the k8s cluster with worker node.
```

## Note: 
In the given file kube-flannel.yml, i have changed the interface details so that we can install the pod flannel network on eth1 interface becasue eth0 is reserved for NAT and also used by vagrant file as well.

## Lets verify the all machines one by one.
1) Firstly we need to clone this repository in any path from where we want to install the machines.
2) Open the ```git bash``` in the software and run the below command.

```
> cd C:\Users\gautam\CloudDrive\vagrant_machine\Office Machine
> vagrant up
```
    
3) Suppose all machines has been installed & now its time to verify all the machines one by one.
```
C:\Users\gautam\CloudDrive\vagrant_machine\Office Machine>vagrant status
Current machine states:

kmaster                   running (virtualbox)
kworker1                  running (virtualbox)
kworker2                  running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.

C:\Users\gautam\CloudDrive\vagrant_machine\Office Machine>
```
```
C:\Users\gautam\CloudDrive\vagrant_machine\Office Machine>vagrant ssh kmaster
Last login: Fri Jan 24 08:23:08 2020 from 10.0.2.2
[vagrant@kmaster ~]$
```
```
[vagrant@kmaster ~]$ kubectl version
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.2", GitCommit:"59603c6e503c87169aea6106f57b9f242f64df89", GitTreeState:"clean", BuildDate:"2020-01-18T23:30:10Z", GoVersion:"go1.13.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.2", GitCommit:"59603c6e503c87169aea6106f57b9f242f64df89", GitTreeState:"clean", BuildDate:"2020-01-18T23:22:30Z", GoVersion:"go1.13.5", Compiler:"gc", Platform:"linux/amd64"}
[vagrant@kmaster ~]$
```
```
[vagrant@kmaster ~]$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.2", GitCommit:"59603c6e503c87169aea6106f57b9f242f64df89", GitTreeState:"clean", BuildDate:"2020-01-18T23:27:49Z", GoVersion:"go1.13.5", Compiler:"gc", Platform:"linux/amd64"}
[vagrant@kmaster ~]$
```
```
[vagrant@kmaster ~]$ systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
   Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
  Drop-In: /usr/lib/systemd/system/kubelet.service.d
           └─10-kubeadm.conf
   Active: active (running) since Fri 2020-01-24 08:13:45 UTC; 1h 2min ago
     Docs: https://kubernetes.io/docs/
 Main PID: 8849 (kubelet)
    Tasks: 17
   Memory: 37.1M
   CGroup: /system.slice/kubelet.service
           └─8849 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --cgroup-dri...
[vagrant@kmaster ~]$
```

```
[vagrant@kmaster ~]$ cat /etc/hosts | grep -i example
127.0.0.1       kmaster.example.com     kmaster
172.28.128.100 kmaster.example.com kmaster
172.28.128.101 kworker1.example.com kworker1
172.28.128.102 kworker2.example.com kworker2
[vagrant@kmaster ~]$
```

```
[vagrant@kmaster ~]$ systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2020-01-24 08:08:00 UTC; 1h 8min ago
     Docs: https://docs.docker.com
 Main PID: 5949 (dockerd)
    Tasks: 17
   Memory: 746.7M
   CGroup: /system.slice/docker.service
           └─5949 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
[vagrant@kmaster ~]$
```
```
[vagrant@kmaster ~]$ docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS               NAMES
d4e43a3a4483        70f311871ae1           "/coredns -conf /etc…"   About an hour ago   Up About an hour                        k8s_coredns_coredns-6955765f44-cztfs_kube-system_1e935d55-03ae-47e7-a870-5151cfbdc537_0
a7b66162a9f6        70f311871ae1           "/coredns -conf /etc…"   About an hour ago   Up About an hour                        k8s_coredns_coredns-6955765f44-n75rf_kube-system_ef01f295-9d05-4f84-bb38-04fdafe814d0_0
114aa46870a2        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_coredns-6955765f44-n75rf_kube-system_ef01f295-9d05-4f84-bb38-04fdafe814d0_0
c8ed929bd5df        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_coredns-6955765f44-cztfs_kube-system_1e935d55-03ae-47e7-a870-5151cfbdc537_0
b7b4fd601624        ff281650a721           "/opt/bin/flanneld -…"   About an hour ago   Up About an hour                        k8s_kube-flannel_kube-flannel-ds-amd64-q74gl_kube-system_1620d56e-3ed2-47de-8e8f-2073b17b9567_0
c573b85594dc        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-flannel-ds-amd64-q74gl_kube-system_1620d56e-3ed2-47de-8e8f-2073b17b9567_0
2db074615f58        cba2a99699bd           "/usr/local/bin/kube…"   About an hour ago   Up About an hour                        k8s_kube-proxy_kube-proxy-zfhxg_kube-system_8204bd68-c153-4d08-983a-a69cf9f5a675_0
4c89309d8039        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-proxy-zfhxg_kube-system_8204bd68-c153-4d08-983a-a69cf9f5a675_0
e7c30d55f179        da5fd66c4068           "kube-controller-man…"   About an hour ago   Up About an hour                        k8s_kube-controller-manager_kube-controller-manager-kmaster.example.com_kube-system_39a083bd62fc59c85a03ab44e7d64515_0
33fde801a44e        303ce5db0e90           "etcd --advertise-cl…"   About an hour ago   Up About an hour                        k8s_etcd_etcd-kmaster.example.com_kube-system_1de69429fc63a45ab591cf8822fa476a_0
133267a360b1        f52d4c527ef2           "kube-scheduler --au…"   About an hour ago   Up About an hour                        k8s_kube-scheduler_kube-scheduler-kmaster.example.com_kube-system_9c994ea62a2d8d6f1bb7498f10aa6fcf_0
4e6ce3e76a54        41ef50a5f06a           "kube-apiserver --ad…"   About an hour ago   Up About an hour                        k8s_kube-apiserver_kube-apiserver-kmaster.example.com_kube-system_1a7637ce0ca8e47b97c6d0472744d1a1_0
a4232757148b        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-controller-manager-kmaster.example.com_kube-system_39a083bd62fc59c85a03ab44e7d64515_0
b4b660c5ba42        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_etcd-kmaster.example.com_kube-system_1de69429fc63a45ab591cf8822fa476a_0
106e1f64f4c3        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-scheduler-kmaster.example.com_kube-system_9c994ea62a2d8d6f1bb7498f10aa6fcf_0
3044e0fe82b5        k8s.gcr.io/pause:3.1   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-apiserver-kmaster.example.com_kube-system_1a7637ce0ca8e47b97c6d0472744d1a1_0
[vagrant@kmaster ~]$
```  

```
[vagrant@kmaster ~]$ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   11m
[vagrant@kmaster ~]$
```
```
[vagrant@kmaster ~]$ kubectl get nodes -o wide
NAME                   STATUS   ROLES    AGE     VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
kmaster.example.com    Ready    master   10m     v1.17.2   172.28.128.100   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://19.3.5
kworker1.example.com   Ready    <none>   5m50s   v1.17.2   172.28.128.101   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://19.3.5
kworker2.example.com   Ready    <none>   91s     v1.17.2   172.28.128.102   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://19.3.5
[vagrant@kmaster ~]$
```
4) Now, we will check all the aliases which are configured during the installation with below given command.
```
[vagrant@kmaster ~]$ alias
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias k='kubectl'
alias kga='kubectl get all'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes -o wide'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias vi='vim'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
[vagrant@kmaster ~]$
```

5) Let configure one deployment and then we will check the connectivity.
```
[vagrant@kmaster ~]$ kubectl run webserver --image=nginx:alpine --port=80
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/webserver created
[vagrant@kmaster ~]$ kga
NAME                             READY   STATUS    RESTARTS   AGE
pod/webserver-5bff76c8f7-p9k84   1/1     Running   0          47s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   69m

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webserver   1/1     1            1           47s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/webserver-5bff76c8f7   1         1         1       47s
[vagrant@kmaster ~]$
[vagrant@kmaster ~]$ kgp -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
webserver-5bff76c8f7-p9k84   1/1     Running   0          69s   10.244.1.3   kworker1.example.com   <none>           <none>
[vagrant@kmaster ~]$
```

6) Lets check if we can access the container or not.
```
[vagrant@kmaster ~]$ curl 10.244.1.3
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
[vagrant@kmaster ~]$
```

## Best of luck for the installation of kubernetes clusters via kubeadm. ###
