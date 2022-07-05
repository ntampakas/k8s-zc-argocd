# zkevm-chain in k8s (non prod version)
## Deploy zkevm-chain + support services to kubernetes cluster

## Deploy metrics server
   ```
   # kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
   # kubectl get deployment metrics-server -n kube-system
   NAME             READY   UP-TO-DATE   AVAILABLE   AGE
   metrics-server   1/1     1            1           32s
   ```

## Deploy ArgoCD
   ```
   # kubectl create namespace argocd
   # kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   # kubectl get pods -n argocd
   argocd-application-controller-0                     1/1     Running   0          42s
   argocd-applicationset-controller-66689cbf4b-m7vq8   1/1     Running   0          45s
   argocd-dex-server-66fc6c99cc-gxfvn                  1/1     Running   0          45s
   argocd-notifications-controller-8f8f46bd6-bk6nn     1/1     Running   0          44s
   argocd-redis-d486999b7-9b2qt                        1/1     Running   0          44s
   argocd-repo-server-7db4cc4b45-vvw5w                 1/1     Running   0          43s
   argocd-server-79d86bbb47-9bwgc                      1/1     Running   0          43s
   ```

## Deploy zkevm-chain
   ```
   # kubectl apply -f zkevm-chain/services/secrets.yaml
   # kubectl apply -f zkevm-chain/services/leader-testnet-geth/deploy.yaml
   # find . -type f -name 'deploy.yaml' -exec kubectl apply -f {} \;
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

## Connect to ArgoCD UI
   ```
   # kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   Access https://localhost:8080 from your browser
   
   ArgoCD credentials:
   
   Username: admin
   
   Password:
   
   ```
   # kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
   ```
   
