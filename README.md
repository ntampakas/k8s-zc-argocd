# zkevm-chain in k8s (non prod version)
## Deploy zkevm-chain + support services to kubernetes cluster

## Deploy EFS storage class, persistent volume claim, and persistent volume
   - Edit pv.yaml and replace volumeHandle with the EFS id retrieved using:
     ```
     # aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --output text
     ```
   - Apply configuration
     ```
     # kubectl apply -f zkevm-chain/efs
     ```
   - Upload all testnet files to EFS
     F.x.:
     ```
     # kubectl apply -f aux/efs-pod.yaml
     # kubectl get pods
     NAME      READY   STATUS    RESTARTS   AGE
     efs-pod   1/1     Running   0          37s
     # kubectl cp ~/zkevm-chain/testnet/init.sh efs-pod:/host # etc.
     # kubectl exec -ti efs-pod -- ls host
     geth.toml                 l1-genesis-template.json  params
     init.sh                   l2-genesis-template.json
     # kubectl delete -f aux/efs-pod.yaml
     ```
     
## Deploy metrics server
   ```
   # kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
   # kubectl get deployment metrics-server -n kube-system
   NAME             READY   UP-TO-DATE   AVAILABLE   AGE
   metrics-server   1/1     1            1           32s
   ```

## Deploy zkevm-chain
   ```
   # kubectl apply -f zkevm-chain/services/
   # kubectl get pods
   NAME                                   READY   STATUS    RESTARTS      AGE
   coordinator-845cd548fd-xjd8r           1/1     Running   0             84s
   l1-testnet-geth-0                      1/1     Running   0             75s
   leader-testnet-geth-0                  1/1     Running   0             69s
   prover-rpcd-78b8bfb7b6-qt8kf           1/1     Running   0             66s
   server-testnet-geth-7d4485df55-kt9q5   1/1     Running   3 (32s ago)   57s
   server-testnet-geth-7d4485df55-s4c9n   1/1     Running   3 (32s ago)   57s
   web-5d76ff855b-5w66d                   1/1     Running   0  
   # kubectl get svc web
   NAME   TYPE           CLUSTER-IP      EXTERNAL-IP                                                                        PORT(S)                          AGE
   web    LoadBalancer   172.20.166.78   asasxzx349-704d9713bbsdx12c8482.elb.eu-central-1.amazonaws.com   80:31723/TCP,443:32717/TCP   2m44s
   ```
