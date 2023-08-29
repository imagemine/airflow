# !/usr/bin/env bash

if [[ ! -z $AIRFLOW_DB_PASSWORD_FILENAME ]]; then
  AIRFLOW_DB_PASSWORD=$(cat $AIRFLOW_DB_PASSWORD_FILENAME)
  if [[ ! -z $AIRFLOW_DB_USERNAME ]] && [[ ! -z $AIRFLOW_DB_DRIVER ]] && [[ ! -z $AIRFLOW_DB_HOST ]] && [[ ! -z $AIRFLOW_DB_PORT ]] && [[ ! -z $AIRFLOW_DB_DATABASE ]]; then
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="$AIRFLOW_DB_DRIVER://$AIRFLOW_DB_USERNAME:$AIRFLOW_DB_PASSWORD@$AIRFLOW_DB_HOST:$AIRFLOW_DB_PORT/$AIRFLOW_DB_DATABASE"
  else
    echo "airflow database, host, port, username are required. Use AIRFLOW_DB_USERNAME and AIRFLOW_DB_HOST and AIRFLOW_DB_PORT and AIRFLOW_DB_DATABASE env to provide the configuration."
  fi
fi

if [[ $AWS_S3_STORAGE_ENABLE ]] ; then
  if [[ ! -z $S3_PROXY_ACCESSKEY_FILENAME ]] && [[ ! -z $S3_PROXY_SECRETKEY_FILENAME ]]; then
    S3_PROXY_ACCESSKEY=$(cat $S3_PROXY_ACCESSKEY_FILENAME)
    S3_PROXY_SECRETKEY=$(cat $S3_PROXY_SECRETKEY_FILENAME)
    if [[ ! -z $AWS_PROXY_HOST ]] && [[ ! -z $AWS_PROXY_PORT ]] && [[ ! -z $AWS_PROXY_REGION_CODE ]]; then
      AIRFLOW_CONN_AWS_S3_STORAGE="aws://$S3_PROXY_ACCESSKEY:$S3_PROXY_SECRETKEY@?host=http%3A%2F%2F$AWS_PROXY_HOST%3A$AWS_PROXY_PORT&region_name=$AWS_REGION_CODE"
    else
      echo "aws host and aws port and aws region code are required. Use AWS_PROXY_HOST and AWS_PROXY_PORT and AWS_PROXY_REGION_CODE env to provide the configuration."
    fi
  else
    echo "s3 access key file and s3 secret key file are required. Use S3_PROXY_SECRETKEY_FILENAME and S3_PROXY_SECRETKEY_FILENAME env to provide the configuration."
  fi
fi