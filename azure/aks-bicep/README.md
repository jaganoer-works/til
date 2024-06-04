# Bicepを利用してAKSクラスターを作成する
AKSクラスター作成をBicepで実施する手順

[参考]
https://learn.microsoft.com/ja-jp/azure/aks/learn/quick-kubernetes-deploy-bicep?tabs=azure-cli

## リソースグループを作成する
```bash
az group create --name <myResourceGroup> --location <japaneast>
```

## SSHキーペアを作成する
```bash
az sshkey create --name mySSHKey --resource-group <myResourceGroup>
```

## デプロイ
```bash
az deployment group create --resource-group myResourceGroup --template-file main.bicep --parameters dnsPrefix=myakscluster linuxAdminUsername=adminuser sshRSAPublicKey='<ssh-key>'
```

## Kubernetesコマンドラインツールのkubectlをダウンロードしてインストール
```bash
az aks install-cli
```

mac osでインストールする場合は下記の手順を参考

[参考]
https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos

## Kubernetes クラスターに接続するように kubectl を構成します。 
```bash
az aks get-credentials --resource-group <myResourceGroup> --name <myAksCluster>
```

## ノード一覧を表示する
```bash
kubectl get nodes

NAME                                STATUS   ROLES   AGE   VERSION
aks-agentpool-27747216-vmss000000   Ready    agent   11m   v1.28.5
aks-agentpool-27747216-vmss000001   Ready    agent   11m   v1.28.5
aks-agentpool-27747216-vmss000002   Ready    agent   11m   v1.28.5
```

## 作成したリソースをすべて削除する
```bash
az group delete --name myResourceGroup --yes --no-wait
```
## スクリプトの使用
デプロイ
```bash
chmod +x deploy-aksCluster.sh
./deploy-aksCluster.sh
```
作成したリソースをすべて削除する
```bash
chmod +x deploy-aksCluster.sh
./delete-aksCluster.sh
```

