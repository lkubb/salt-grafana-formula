# vim: ft=sls

{#-
    Installs the grafana package and a necessary service override
    to include custom secrets via an env vars file.
#}

include:
  - .install
