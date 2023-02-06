# vim: ft=sls

{#-
    This state will remove the configured grafana repository.
    This works for apt/dnf/yum/zypper-based distributions only by default.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana with context %}


{%- if grafana.lookup.pkg_manager not in ["apt", "dnf", "yum", "zypper"] %}
{%-   if salt["state.sls_exists"](slsdotpath ~ "." ~ grafana.lookup.pkg_manager ~ ".clean") %}

include:
  - {{ slsdotpath ~ "." ~ grafana.lookup.pkg_manager ~ ".clean" }}
{%-   endif %}

{%- else %}
{%-   for reponame, enabled in grafana.lookup.enablerepo.items() %}
{%-     if enabled %}

Grafana {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-       for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-         if conf in grafana.lookup.repos[reponame] %}
    - {{ conf }}: {{ grafana.lookup.repos[reponame][conf] }}
{%-         endif %}
{%-       endfor %}
{%-     endif %}
{%-   endfor %}
{%- endif %}
