# vim: ft=sls

{#-
    Removes the Grafana and the service unit overrides.
    Has a depency on `grafana.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

include:
  - {{ sls_config_clean }}
  - {{ slsdotpath }}.repo.clean

Grafana service unit overrides are absent:
  file.absent:
    - name: {{ grafana.lookup.paths.unit_file }}

Grafana is removed:
  pkg.removed:
    - name: {{ grafana.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
