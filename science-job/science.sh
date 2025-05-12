#!/bin/bash

echo "I'm running on" $(hostname -f) "on the resource $OSG_SITE_NAME"
echo "My architechture is" $(arch)

echo
echo

python3 sk-learn-example.py

