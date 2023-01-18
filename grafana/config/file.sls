# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Grafana configuration is managed:
  file.managed:
    - name: {{ grafana.lookup.config }}
    - source: {{ files_switch(['grafana.ini', 'grafana.ini.j2'],
                              lookup='Grafana configuration is managed'
                 )
              }}
    - mode: '0640'
    - user: root
    - group: {{ grafana.lookup.group }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        grafana: {{ grafana | json }}

Grafana secrets are managed:
  file.managed:
    - name: {{ grafana.lookup.paths.env_file }}
    - source: {{ files_switch(['grafana.env', 'grafana.env.j2'],
                              lookup='Grafana secrets are managed'
                 )
              }}
    - mode: '0600'
    - user: root
    - group: {{ grafana.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - show_changes: false
    - require:
      - sls: {{ sls_package_install }}
    - context:
        grafana: {{ grafana | json }}

Grafana provisioning configuration is managed:
  file.recurse:
    - name: {{ grafana.lookup.paths.provisioning }}
    - source: {{ files_switch(['provisioning'],
                              lookup='Grafana provisioning configuration is managed'
                 )
              }}
    - file_mode: '0640'
    - dir_mode: '0750'
    - user: root
    - group: {{ grafana.lookup.group }}
    - clean: true
    - exclude_pat:
      - '\.gitkeep'
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        grafana: {{ grafana | json }}
