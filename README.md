ztrustee
=============

Recipes
-------

* `default` - Installs Gazzang zTrustee client
* `server` - Installs and configures Gazzang zTrustee server

Attributes
----------

The following attributes are required when using the ztrustee::server recipe

* `node['ztrustee']['repo_username']` – username for Gazzang's yum repository *(default: nil)*
* `node['ztrustee']['repo_password']` – password for Gazzang's yum repository *(default: nil)*
