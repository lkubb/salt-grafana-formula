# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ slsdotpath }}.repo

Grafana is installed:
  pkg.installed:
    - name: {{ grafana.lookup.pkg.name }}
    - version: {{ grafana.version or "null" }}

# In the default configuration, this is used
# for injecting another environment file that contains
# secrets, which are usable in provisioning files.
Grafana service unit overrides are installed:
  file.managed:
    - name: {{ grafana.lookup.paths.unit_file }}
    - source: {{ files_switch(["grafana-server.service", "grafana-server.service.j2"],
                              lookup="Grafana service unit overrides are installed"
                 )
              }}
    - user: root
    - group: {{ grafana.lookup.rootgroup }}
    - mode: '0644'
    - makedirs: true
    - template: jinja
    - require:
      - Grafana is installed
    - context:
        grafana: {{ grafana | json }}
