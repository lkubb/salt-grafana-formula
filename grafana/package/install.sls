# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

include:
  - {{ slsdotpath }}.repo

grafana-package-install-pkg-installed:
  pkg.installed:
    - name: {{ grafana.lookup.pkg.name }}
    - version: {{ grafana.version or "null" }}
