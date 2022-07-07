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
   # find . -type f -name 'deploy.yaml' -exec kubectl apply -f {} \;
   # kubectl get pods
   NAME                                   READY   STATUS    RESTARTS      AGE
   bootnode-0                             1/1     Running   0          19h
   coordinator-8589869649-gz2s8           1/1     Running   0          18h
   l1-testnet-geth-0                      1/1     Running   0          19h
   leader-testnet-geth-0                  1/1     Running   0          19h
   prover-rpcd-65b666564-vh6js            1/1     Running   0          18h
   server-testnet-geth-558d575c66-g55lv   1/1     Running   0          19h
   server-testnet-geth-558d575c66-qqdc7   1/1     Running   0          19h
   web-6d595dbbb4-qpklp                   1/1     Running   0          4m27s
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
   
