Workstream
==========

Singleton
---------
`/terraform/partials/singleton` is a simple terraform submodule that builds just a small part of the examples in this repo.

Getting started
---------------

The pre-requisites for this submodule are broadly identical to the pre-requisites for this repo as a whole.

From the terraform root folder ([/terraform](./terraform)) run:

```terraform plan partials/singleton```

then, if you're happy with the output

```terraform apply partials/singleton```

As ever don't forget to clean up afterwards

```terraform destroy```

