# vim: ft=sls

{#-
    Starts the grafana service and enables it at boot time.
    Has a dependency on `grafana.config`_ and grafana.cert`_.
#}

include:
  - .running
