# vim: ft=sls

{#-
    *Meta-state*.

    This installs the grafana package + mandatory service override,
    manages the grafana configuration file,
    generates a TLS certificate and key
    and then starts the associated grafana service.
#}

include:
  - .package
  - .config
  - .cert
  - .service
