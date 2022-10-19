## Deployment of Streaming Server on EKS 

1. create EKS Cluster

```bash
export cluster_name=test-cluster-sr
export node_group_name=node-west-1
export service_account=test_eks_sa

eksctl create cluster \
--name ${cluster_name} \
--version 1.23 \
--region eu-west-1 \ 
--nodegroup-name ${node_group_name} \
--node-type m5.large \
--nodes 2

1. Connect using the Kubeconfig file created and create alias 

```bash
export KUBECONFIG=/Users/jusi/.kube/config
alias k='kubectl'
alias kap='kubectl apply -f'
```

2. Check if there is storage class or any pvs

# Get storage class  

```bash
k get sc && k get pv
NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
gp2 (default)   kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  19m
```

There is already by default a storage class on the cluster but EKS role doesn't have permission to create dynamic EBS volume.

As the Storage Class is already created on K8S v1.23 and already set as default, I don't need to create any Storage Class. :relaxed:

Moreover, The Storage class is defined as "WaitForFirstConsumer" so the PVC will not be bind until the pod using this pvc is created.

:info: If we try to create any PVC without creating any PV or without dynamic provisioning using storage class, the PVC will stay in pending mode.

3. Give the permission to the EKS Cluster 

This documentation was followed to add the permission for the Service account to be able to create dynamic EBS volume

[eks-persistent-storage](https://aws.amazon.com/premiumsupport/knowledge-center/eks-persistent-storage/)

Once, this is configured, no need to create any Persistent Volume and we will be able to use only Persistent Volume Claim dynamically.

## Deployment of the pods, pvc and services

This command will deploy all the yml files in the manifests directory.

```bash
k apply -f manifests
```

## Description and explanation

I've add a InitContainer for the streaming server deployment to create a directory and give permission as the container was never starting and has this error:

```bash  
k logs streaming-server-6998587d9c-7m5qm                                 
nginx: [emerg] mkdir() "/var/lib/streaming/hls/" failed (13: Permission denied)
```

3 services(svc) were created:
- 1 ClusterIP ( default ) as it will be only internal
- 2 Load Balancer's Type to be publicly accessible 

I was able to connect on both ALB URL ( on port 1935 with OBS and from curl for port ) that I get from the svc but I have issue on the Nginx/streaming server ( Forbidden )


```bash
k get svc                                
NAME                        TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)          AGE
kubernetes                  ClusterIP      10.100.0.1       <none>                                                                    443/TCP          10h
streaming-consumer          LoadBalancer   10.100.177.117   a56c0f9bec4bf4b05bbe0b00d5b2f8d6-1896631646.eu-west-1.elb.amazonaws.com   9999:31077/TCP   7h22m
streaming-server-external   LoadBalancer   10.100.43.5      a549243e74b1a4c4fb481f18d7361d65-106262341.eu-west-1.elb.amazonaws.com    1935:31095/TCP   3h57m
streaming-server-internal   ClusterIP      10.100.10.47     <none>                                                                    8080/TCP         6h2m
```

Issue with Nginx:

```
curl http://a56c0f9bec4bf4b05bbe0b00d5b2f8d6-1896631646.eu-west-1.elb.amazonaws.com:9999/
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.15.8</center>
</body>
</html>
```

I have the same issue using the docker-compose. 

From my test and research, it's not an error from my deployment and configuration but an error from the docker image and the permission.
