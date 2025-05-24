# ArgoCD Sample Project

このプロジェクトは、ArgoCDを使用したKubernetesアプリケーションのデプロイメントサンプルです。
Kindクラスター上でArgoCDをセットアップし、ArgoCDでサンプルアプリケーションとしてPrometheusとGrafanaをdeployする方法を示しています。

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
   helm install argocd 
   ```

3. PrometheusとGrafanaのデプロイ
   ```
   k create ns prometheus
   k create ns grafana
   helm install argo-app charts/argo-app
   ```

## アクセス情報

- ArgoCD UI: http://localhost:30080
- Grafana: http://localhost:31000

## 注意事項

- このプロジェクトは検証環境での使用を想定しています。本番環境に使わないようにお願いします
- ポート番号は必要に応じて`kind-config.yaml`で変更可能です
