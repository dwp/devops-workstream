Workstream
==========

Testspace
---------
`/terraform/partials/testspace` is an empty terraform submodule set up for you to experiment with your own config.  Either directly code resources yourself, or import other terraform modules from this repo to build sandbox infrastructure.

Getting started
---------------

The pre-requisites for this submodule are broadly identical to the pre-requisites for this repo as a whole.

From the terraform root folder ([/terraform](./terraform)) run:

```terraform plan partials/testspace```

then, if you're happy with the output

```terraform apply partials/testspace```

As ever don't forget to clean up afterwards

```terraform destroy```

File structure
--------------
This submodule contain a set of files for you to modify and extend:

* [README.md](/terraform/partials/testspace/README.md) - these instructions
* [main.tf](/terraform/partials/testspace/main.tf) - main terraform file
* [variables.tf](/terraform/partials/testspace/variables.tf) - input variables and defaults

  