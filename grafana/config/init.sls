# vim: ft=sls

{#-
    Manages the grafana service configuration, including provisioning files and environment secrets.
    Has a dependency on `grafana.package`_.
#}

include:
  - .file
