# vim: ft=sls

{#-
    Removes the generated TLS certificate/key.
    Depends on `grafana.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

include:
  - {{ sls_service_clean }}

{%- if grafana.config | traverse("server:cert_file") and grafana.config | traverse("server:cert_key") %}

grafana key/cert is absent:
  file.absent:
    - names:
      - {{ grafana.config | traverse("server:cert_file") }}
      - {{ grafana.config | traverse("server:cert_key") }}
    - require:
      - sls: {{ sls_service_clean }}
{%- endif %}
