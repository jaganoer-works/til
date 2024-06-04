#!/bin/bash

echo "警告: この操作により、現在のAzureサブスクリプションの全てのリソースグループが永久に削除されます。"
echo "本番環境では絶対に実行しないでください。"

read -p "本当に全てのAzureリソースグループを削除しますか？[y/N]: " answer
case $answer in
  [Yy]* ) 
    for rg in $(az group list --query "[].name" -o tsv)
    do
      echo "削除するリソースグループ: $rg"
      if ! az group delete --name $rg --yes --no-wait; then
        echo "エラー: リソースグループ '$rg' の削除に失敗しました。"
        exit 1
      fi
    done
    echo "リソースグループの削除を開始しました。"
    ;;
  * ) 
    echo "操作はキャンセルされました。"
    ;;
esac