# vim: ft=yaml
---
grafana:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    pkg:
      name: grafana
    enablerepo:
      stable: true
    config: '/etc/grafana/grafana.ini'
    service:
      name: grafana-server
    group: grafana
    paths:
      conf: /etc/grafana
      dashboards: /etc/grafana/dashboards
      data: /var/lib/grafana
      env_file: /etc/grafana/grafana.env
      home: /usr/share/grafana
      log: /var/log/grafana
      plugins: /var/lib/grafana/plugins
      provisioning: /etc/grafana/provisioning
      run: /run/grafana
      unit_file: /etc/systemd/system/grafana-server.service
    user: grafana
  cert:
    ca_server: null
    cn: null
    days_remaining: 7
    days_valid: 30
    intermediate: []
    signing_cert: null
    signing_policy: null
    signing_private_key: null
  config:
    analytics:
      reporting_enabled: false
    security:
      secret_key: null
    users:
      allow_sign_up: false
  secrets: {}
  version: null

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://grafana/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   grafana-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      grafana-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
