# multiarch-apptainer

This guide demonstrates how to build and run Apptainer containers across
multiple CPU architectures in the OSG OSPool.

Why might you want to do this? Multi-architecture (multiarch) Apptainer
containers are increasingly important for two reasons:

1. Many users rely on complex software stacks that are best managed
   within containers.

2. The OSPool now includes a growing number of ARM64 machines. While the
   ARM64 pool is currently small, it is underutilized, and we expect it
   to expand. By using multiarch containers, you may gain access to
   additional computing resources.


## Step 1: Build

In the `container-build` directory, you'll find a sample Apptainer
definition file named `container.def`. This same file is used to build
containers for both ARM64 (aarch64) and X86_64 architectures, so it's
important that the base image supports both platforms. In this example,
we use ubuntu:24.04 as the base image, which is multiarch-compatible.

The job.sub file targets both platforms using the `queue ... from` list
syntax:

```
queue targetarch from (
  aarch64
  x86_64
)
```

This creates two build jobs—one for each architecture. The resulting `.sif`
files will be moved to your OSDF directory, making them easy to serve to
your science jobs in Step 2. Be sure to update the `transfer_output_remaps`
path to reflect your access point and user.


## Step 2: Science Job

The `science-job` directory shows how to use the multiple container images
created in Step 1. To run on both architectures, you need to explicitly
tell HTCondor to allow it by setting the appropriate `requirements` 
expression. By default, jobs are restricted to run only on the same
architecture as the access point (typically x86_64).

You must also use the `$$(Arch)` syntax in the `container_image` attribute.
The double-dollar syntax instructs HTCondor to evaluate the value _after_
the job has matched to a slot - ensuring the correct container image is
selected for the slot's architecture.

