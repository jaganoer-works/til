#!/bin/bash

# リソースグループの名前とロケーションを設定
resourceGroup="myResourceGroup"
location="japaneast"
aksClusterName="myAksCluster"
sshKeyName="mySSHKey"
dnsPrefix="myakscluster"
adminUsername="adminuser"

# リソースグループを作成
echo "リソースグループを作成中..."
az group create --name $resourceGroup --location $location

# SSHキーペアを作成
echo "SSHキーペアを作成中..."
sshKey=$(az sshkey create --name $sshKeyName --resource-group $resourceGroup --query "publicKey" -o tsv)

# Bicep テンプレートを用いたデプロイ
echo "BicepテンプレートによるAKSクラスターのデプロイを開始..."
az deployment group create --resource-group $resourceGroup --template-file main.bicep --parameters dnsPrefix=$dnsPrefix linuxAdminUsername=$adminUsername sshRSAPublicKey="$sshKey"

# kubectlのインストール
# echo "kubectlをインストール中..."
# az aks install-cli

# AKSクラスターに接続
echo "AKSクラスターに接続中..."
az aks get-credentials --resource-group $resourceGroup --name $aksClusterName

# ノード一覧を表示
echo "クラスターのノード一覧を表示..."
kubectl get nodes