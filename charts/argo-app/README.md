# Argo CD ApplicationSet Helm Chart

このHelmチャートは、Argo CDのApplicationSetを用いてhelmベースでアプリケーションのデプロイを行うChartです。

## Usage

### Installation

```bash
# 本番環境
helm install argo-app ./charts/argo-app

# 開発環境
helm install argo-app-dev ./charts/argo-app -f ./charts/argo-app/values-dev.yaml
```

### Upgrade

```bash
# 本番環境
helm upgrade argo-app ./charts/argo-app

# 開発環境
helm upgrade argo-app-dev ./charts/argo-app -f ./charts/argo-app/values-dev.yaml
```

## 設定パラメータ

| パラメータ | 説明 | デフォルト値 |
|-----------|------|------------|
| `applicationSet.name` | ApplicationSet name | `application-set` |
| `applicationSet.project` | Argo CD Project name | `default` |
| `applicationSet.valueSourceRepo.url` | valuesファイルのRepo URL | `https://github.com/V01d42/argocd-sample` |
| `applicationSet.valueSourceRepo.ref` | valuesファイルのRepo ref | `values` |
| `applicationSet.valueSourceRepo.targetRevision` | ソースリポジトリのRevision | `main` |
| `applicationSet.syncPolicy` | syncPolicy | AutoSync等 |
| `applicationSet.defaults` | デフォルト設定 | Cluster URL等 |
| `applicationSet.defaults.cluster` | デフォルトのクラスターURL | `https://kubernetes.default.svc` |
| `applicationSet.defaults.valuesFile` | デフォルトのvaluesファイル名 | `values.yaml` or `values-dev.yaml` |
| `applicationSet.applications` | アプリケーションの配列 | 各種Helm Chart |

### Application Setting

各アプリケーションには以下のパラメータを設定可能です。

```yaml
applications:
  - name: app-name          # Application Name
    cluster: cluster-url    # Cluster URL（省略時はデフォルト値を使用）
    repoURL: chart-repo-url # Helm Chart Repo URL
    chart: chart-name       # Helm Chart Name
    repoRevision: version   # Helm Chart Version
    path: app-path          # valueSourceRepoにおけるvaluesファイルへのpath
    namespace: namespace    # デプロイ先のNamespace
```

## Customize Example

新しいアプリケーションを追加する場合：

```yaml
applicationSet:
  applications:
    - name: new-app
      repoURL: https://example.com/charts
      chart: new-app
      repoRevision: 1.0.0
      path: new-app
      namespace: new-app
``` 