# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``grafana`` meta-state
    in reverse order, i.e.
    stops the service,
    removes the TLS certificate and key,
    removes the configuration file and then
    uninstalls the package + service override.
#}

include:
  - .service.clean
  - .cert.clean
  - .config.clean
  - .package.clean
