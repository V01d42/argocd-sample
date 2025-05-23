#!/bin/bash

# Kindクラスター名
CLUSTER_NAME="kind"
# Kind設定ファイル
CONFIG_FILE="kind-config.yaml"

# kind cluster listに指定したクラスター名が存在するかチェック
# grep の結果で判断するため、--name フラグは使用しない
if kind get clusters | grep -q "${CLUSTER_NAME}"; then
  echo "Cluster '${CLUSTER_NAME}' already exists. Deleting it..."
  # kind delete cluster の --name フラグを削除し、直接クラスター名を引数として渡す
  kind delete cluster -n "${CLUSTER_NAME}"
  if [ $? -eq 0 ]; then
    echo "Cluster '${CLUSTER_NAME}' deleted successfully."
  else
    echo "Failed to delete cluster '${CLUSTER_NAME}'."
    exit 1
  fi
else
  echo "Cluster '${CLUSTER_NAME}' does not exist. Creating it..."
  # kind-config.yaml が存在するか確認
  if [ -f "${CONFIG_FILE}" ]; then
    kind create cluster --name "${CLUSTER_NAME}" --config "${CONFIG_FILE}"
    if [ $? -eq 0 ]; then
      echo "Cluster '${CLUSTER_NAME}' created successfully using '${CONFIG_FILE}'."
    else
      echo "Failed to create cluster '${CLUSTER_NAME}'."
      exit 1
    fi
  else
    echo "Error: '${CONFIG_FILE}' not found. Please create this file or adjust the CONFIG_FILE variable."
    exit 1
  fi
fi

echo "Script finished."
