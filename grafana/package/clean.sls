# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

include:
  - {{ sls_config_clean }}
  - {{ slsdotpath }}.repo.clean

grafana-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ grafana.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
