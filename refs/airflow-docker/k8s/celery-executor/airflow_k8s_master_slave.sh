#!/bin/bash
# Written by Mutlu Polatcan
# 18.12.2019
# -------------------------

K8S_FILE_PATHS=(
  # ----------- Rbac -------------
  "rbac/airflow_serviceaccount.yml"
  "rbac/airflow_role.yml"
  "rbac/airflow_rolebinding.yml"
  # ------ Configurations --------
  "configuration/airflow.yml"
  "configuration/airflow_secret.yml"
  #"configuration/postgres.yml" Containerized Postgresql configuration if Postgresql not managed service comment out line
  # --------- Services -----------
  "service/master-slave-cluster/airflow_master.yml"
  #"service/common/postgres.yml" Containerized Postgresql service definition if Postgresql not managed service comment out line
  #"service/common/redis.yml" Containerized Redis service definition
  # -------- Deployments ---------
  "deployment/master-slave-cluster/airflow_master.yml"
  "deployment/master-slave-cluster/airflow_worker.yml"
  #"deployment/common/postgres.yml" Containerized Postgresql deployment if Postgresql not managed service comment out line
  #"deployment/common/redis.yml" Containerized Redis deployment if Redis not managed service comment out line
  # --------- Persistence --------
  "persistence/airflow_nfs_ro.yml"
  "persistence/airflow_nfs_rw.yml"
  # ----------- Ingress ----------
  "ingress/master-slave-cluster/airflow_ui.yml"
  # ------------------------------
)

for K8S_FILE_PATH in ${K8S_FILE_PATHS[@]}; do
  kubectl $1 -f $K8S_FILE_PATH
done
