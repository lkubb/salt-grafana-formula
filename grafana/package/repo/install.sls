# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}

{%- if grains['os'] in ['Debian', 'Ubuntu'] %}

Ensure Grafana APT repository can be managed:
  pkg.installed:
    - pkgs:
      - python3-apt                   # required by Salt
{%-   if 'Ubuntu' == grains['os'] %}
      - python-software-properties    # to better support PPA repositories
{%-   endif %}
{%- endif %}

{%- for reponame, enabled in grafana.lookup.enablerepo.items() %}
{%-   if enabled %}

Grafana {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in grafana.lookup.repos[reponame].items() %}
    - {{ conf }}: {{ val }}
{%-     endfor %}
{%-     if grafana.lookup.pkg_manager in ['dnf', 'yum', 'zypper'] %}
    - enabled: 1
{%-     endif %}
    - require_in:
      - grafana-package-install-pkg-installed

{%-   else %}

Grafana {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-       if conf in grafana.lookup.repos[reponame] %}
    - {{ conf }}: {{ grafana.lookup.repos[reponame][conf] }}
{%-       endif %}
{%-     endfor %}
    - require_in:
      - grafana-package-install-pkg-installed
{%-   endif %}
{%- endfor %}
