ARG BASE_VERSION=2.7.1-python3.10
FROM apache/airflow:${BASE_VERSION}
USER root
RUN mkdir -p /opt/app
RUN mv /opt/airflow /opt/airflow-template
COPY --chown=airflow:root entrypoint/entrypoint.sh /opt/app/entrypoint.sh
COPY --chown=airflow:root conf/airflow.cfg /opt/airflow-template/airflow.cfg
COPY --chown=airflow:root conf/webserver_config.py /opt/airflow-template/webserver_config.py
COPY --chown=airflow:root conf/airflow_local_settings.py /opt/airflow-template/airflow_local_settings.py
RUN chmod a+x /opt/app/entrypoint.sh && chown -R airflow /opt/app /opt/airflow
VOLUME [ "/opt/airflow" ]

USER airflow
RUN /usr/local/bin/python -m pip install --upgrade pip && \
    pip3 install "apache-airflow[password]" && \
    pip3 install "apache-airflow[postgres]" && \
    pip3 install "apache-airflow[cncf.kubernetes]" && \
    pip3 install oauth2client authlib
RUN rm -rf /home/airflow/.local/lib/python3.10/site-packages/gevent/tests
RUN rm -rf /home/airflow/.local/lib/python3.10/site-packages/slapdtest/certs
RUN rm -rf /home/airflow/.local/lib/python3.10/site-packages/tornado/test
WORKDIR "/opt/work"
ENTRYPOINT ["/opt/app/entrypoint.sh"]
