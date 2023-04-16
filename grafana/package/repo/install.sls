# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

# There is no need for python-apt anymore.

{%- for reponame, enabled in grafana.lookup.enablerepo.items() %}
{%-   if enabled %}

Grafana {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in grafana.lookup.repos[reponame].items() %}
    - {{ conf }}: {{ val }}
{%-     endfor %}
{%-     if grafana.lookup.pkg_manager in ["dnf", "yum", "zypper"] %}
    - enabled: 1
{%-     endif %}
    - require_in:
      - Grafana is installed

{%-   else %}

Grafana {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-       if conf in grafana.lookup.repos[reponame] %}
    - {{ conf }}: {{ grafana.lookup.repos[reponame][conf] }}
{%-       endif %}
{%-     endfor %}
    - require_in:
      - Grafana is installed
{%-   endif %}
{%- endfor %}
