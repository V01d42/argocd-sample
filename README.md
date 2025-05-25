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

2. ArgoCD, Prometheus, GrafanaのHelm Repoへの追加
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
```

3. ArgoCDのインストール
```bash
k create ns argocd
helm install -n argocd argocd argo/argo-cd -f ./charts/argocd/values.yaml
```

4. ArgoCD ApplicationSetのデプロイ
これによりApplicationとして登録されているPrometheusとGrafanaがデプロイされます。
```bash
helm install -n argocd argo-app ./charts/argo-app/ -f ./charts/argo-app/values.yaml
```

## ArgoCDの挙動確認
ArgoCDでレポジトリの変更を検知してCDする挙動は、このレポジトリをForkすることで確認できます。

1. GitHubでこのリポジトリをFork

2. `charts/argo-app/values.yaml`もしくは`charts/argo-app/values-dev.yaml`の`applicationSet.valueSourceRepo.url`を先程Forkした自身のGithub Repo URLに変更
```bash
applicationSet:
  name: application-set
  project: default
  valueSourceRepo:
    url: https://github.com/{your-username}/argocd-sample
    ref: values
    targetRevision: main
```

3. ArgoCDのインストール
```bash
k create ns argocd
helm install -n argocd argocd argo/argo-cd -f ./charts/argocd/values.yaml
```

4. ArgoCD ApplicationSetのデプロイ
```bash
helm install -n argocd argo-app ./charts/argo-app/ -f ./charts/argo-app/values.yaml
```

5. Forkしたリポジトリで変更を加えて`main`にPushすると、ArgoCDが自動的に変更を検知してデプロイします
   - `charts/prometheus/values.yaml`や`charts/grafana/values.yaml`の値を変更してみましょう
   - 変更をプッシュ後、ArgoCDのUIで同期状態を確認できます

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
