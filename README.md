# ArgoCD Sample Project

このプロジェクトは、ArgoCDのApplicationSetを使用したデプロイメントサンプルです。
Kindクラスター上でArgoCDをセットアップし、ArgoCDでサンプルアプリケーションとしてPrometheusとGrafanaをdeployしています。

## プロジェクト構成

```
.
├── charts/              # Helmチャート
│   ├── argocd/         # ArgoCDのインストール用チャート
│   ├── prometheus/     # Prometheusのインストール用チャート
│   ├── grafana/        # Grafanaのインストール用チャート
│   └── argo-app/       # Argo ApplicationSet用チャート
├── kind-config.yaml    # Kindクラスター設定
└── cluster-setup.sh    # クラスターセットアップスクリプト
```

## 前提条件

- Docker
- Kind (オプション)
- kubectl
- Helm

## セットアップ手順

1. Kindクラスターの作成（kind環境のみ）
```bash
./cluster-setup.sh
```

2. ArgoCDのインストール
```bash
k create ns argocd
helm install -n argocd argocd argo/argo-cd -f ./charts/argocd/values.yaml
```

3. PrometheusとGrafanaのデプロイ
```bash
k create ns prometheus
k create ns grafana
helm install -n argocd argo-app ./charts/argo-app/ -f ./charts/argo-app/values.yaml
```

## アクセス情報
- ArgoCD UI: http://localhost:30080
- Grafana: http://localhost:31000

Grafanaのusernameは`admin`、passwordも`admin`です。
ArgoCDのusernameは`admin`、passwordは以下のコマンドから確認してください。
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## 注意事項

- このプロジェクトは検証環境での使用を想定しています。本番環境に使わないようにお願いします
- ポート番号は必要に応じて`kind-config.yaml`で変更可能です
