# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

include:
  - {{ sls_config_file }}

{%- if grafana.config | traverse("server:cert_key") and grafana.config | traverse("server:cert_file") %}

Grafana HTTP certificate private key is managed:
  x509.private_key_managed:
    - name: {{ grafana.config.server.cert_key }}
    - algo: rsa
    - keysize: 2048
    - new: true
{%-   if salt["file.file_exists"](grafana.config.server.cert_key) %}
    - prereq:
      - Grafana HTTP certificate is managed
{%-   endif %}
    - makedirs: True
    - user: {{ grafana.lookup.user }}
    - group: {{ grafana.lookup.group }}
    - require:
      - sls: {{ sls_config_file }}

Grafana HTTP certificate is managed:
  x509.certificate_managed:
    - name: {{ grafana.config.server.cert_file }}
    - ca_server: {{ grafana.cert.ca_server or "null" }}
    - signing_policy: {{ grafana.cert.signing_policy or "null" }}
    - signing_cert: {{ grafana.cert.signing_cert or "null" }}
    - signing_private_key: {{ grafana.cert.signing_private_key or (grafana.config.server.cert_file if not grafana.cert.ca_server and not grafana.cert.signing_cert else "null") }}
    - private_key: {{ grafana.config.server.cert_key }}
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
    - subjectAltName:
      - dns: {{ grafana.cert.cn or grains.fqdns | first | d(grafana.config.get("instance_name", grains.id)) }}
    - CN: {{ grafana.cert.cn or grains.fqdns | first | d(grafana.config.get("instance_name", grains.id)) }}
    - mode: '0640'
    - user: {{ grafana.lookup.user }}
    - group: {{ grafana.lookup.group }}
    - makedirs: True
    - append_certs: {{ grafana.cert.intermediate | json }}
    - require:
      - sls: {{ sls_config_file }}
{%-   if not salt["file.file_exists"](grafana.config.server.cert_key) %}
      - Grafana HTTP certificate private key is managed
{%-   endif %}
{%- endif %}
