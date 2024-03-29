Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``grafana``
^^^^^^^^^^^
*Meta-state*.

This installs the grafana package + mandatory service override,
manages the grafana configuration file,
generates a TLS certificate and key
and then starts the associated grafana service.


``grafana.package``
^^^^^^^^^^^^^^^^^^^
Installs the grafana package and a necessary service override
to include custom secrets via an env vars file.


``grafana.package.repo``
^^^^^^^^^^^^^^^^^^^^^^^^
This state will install the configured grafana repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``grafana.config``
^^^^^^^^^^^^^^^^^^
Manages the grafana service configuration, including provisioning files and environment secrets.
Has a dependency on `grafana.package`_.


``grafana.cert``
^^^^^^^^^^^^^^^^
Generates a TLS certificate and key.
Depends on `grafana.config`_.


``grafana.service``
^^^^^^^^^^^^^^^^^^^
Starts the grafana service and enables it at boot time.
Has a dependency on `grafana.config`_ and `grafana.cert`_.


``grafana.clean``
^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``grafana`` meta-state
in reverse order, i.e.
stops the service,
removes the TLS certificate and key,
removes the configuration file and then
uninstalls the package + service override.


``grafana.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the Grafana and the service unit overrides.
Has a dependency on `grafana.config.clean`_.


``grafana.package.repo.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This state will remove the configured grafana repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``grafana.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the Grafana configuration, including provisioning files,
the env file containing secrets and cached autogenerated secrets.
Has a dependency on `grafana.service.clean`_.


``grafana.cert.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes the generated TLS certificate/key.
Depends on `grafana.service.clean`_.


``grafana.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the grafana service and disables it at boot time.


