# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

include:
  - {{ sls_service_clean }}

grafana-config-clean-file-absent:
  file.absent:
    - names:
      - {{ grafana.lookup.config }}
      - {{ grafana.lookup.paths.provisioning }}
      - {{ grafana.lookup.paths.conf | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
