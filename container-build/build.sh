#!/bin/bash

set -e

targetarch=$1
apptainer build ${targetarch}.sif container.def 2>&1


