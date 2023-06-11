# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Grafana configuration is managed:
  file.managed:
    - name: {{ grafana.lookup.config }}
    - source: {{ files_switch(
                    ["grafana.ini", "grafana.ini.j2"],
                    config=grafana,
                    lookup="Grafana configuration is managed",
                 )
              }}
    - mode: '0640'
    - user: root
    - group: {{ grafana.lookup.group }}
    - makedirs: true
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        grafana: {{ grafana | json }}

# TODO: LoadCredential
# https://www.freedesktop.org/software/systemd/man/systemd.exec.html#Credentials
Grafana secrets are managed:
  file.managed:
    - name: {{ grafana.lookup.paths.env_file }}
    - source: {{ files_switch(
                    ["grafana.env", "grafana.env.j2"],
                    config=grafana,
                    lookup="Grafana secrets are managed",
                 )
              }}
    - mode: '0600'
    - user: root
    - group: {{ grafana.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - show_changes: false
    - require:
      - sls: {{ sls_package_install }}
    - context:
        grafana: {{ grafana | json }}

Grafana provisioning configuration is managed:
  file.recurse:
    - name: {{ grafana.lookup.paths.provisioning }}
    - source: {{ files_switch(
                    ["provisioning"],
                    config=grafana,
                    lookup="Grafana provisioning configuration is managed",
                 )
              }}
    - file_mode: '0640'
    - dir_mode: '0750'
    - user: root
    - group: {{ grafana.lookup.group }}
    - clean: true
    - exclude_pat:
      - '*/.gitkeep'
    - include_empty: true
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        grafana: {{ grafana | json }}


Grafana dashboards are managed:
  file.recurse:
    - name: {{ grafana.lookup.paths.dashboards }}
    - source: {{ files_switch(
                    ["dashboards"],
                    config=grafana,
                    lookup="Grafana dashboards are managed",
                 )
              }}
    - file_mode: '0644'
    - dir_mode: '0755'
    - user: root
    - group: {{ grafana.lookup.group }}
    - clean: true
    - exclude_pat:
      - '*/.gitkeep'
    - include_empty: true
    - require:
      - sls: {{ sls_package_install }}
