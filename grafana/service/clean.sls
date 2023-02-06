# vim: ft=sls

{#-
    Stops the grafana service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

Grafana is dead:
  service.dead:
    - name: {{ grafana.lookup.service.name }}
    - enable: false
