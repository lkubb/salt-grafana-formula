# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- set sls_cert_managed = tplroot ~ ".cert.managed" %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

include:
  - {{ sls_config_file }}
  - {{ sls_cert_managed }}

Grafana is running:
  service.running:
    - name: {{ grafana.lookup.service.name }}
    - enable: true
    - watch:
      - sls: {{ sls_config_file }}
{%- if grafana.config | traverse("server:cert_key") and grafana.config | traverse("server:cert_file") %}
      - sls: {{ sls_cert_managed }}
{%- endif %}

{%- if grafana.manage_firewalld and "firewall-cmd" | which %}

Grafana service is known:
  firewalld.service:
    - name: grafana
    - ports:
      - {{ grafana | traverse("config:server:http_port", "3000") }}/tcp
    - require:
      - Grafana is running

Grafana ports are open:
  firewalld.present:
    - name: public
    - services:
      - grafana
    - require:
      - Grafana service is known
{%- endif %}
