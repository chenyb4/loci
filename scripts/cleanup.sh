#!/bin/bash

set -ex

yum clean all

# NOTE(SamYaple): Removing this file allows python to use libraries outside of
# the virtualenv if they do not exist inside the venv. This is a requirement
# for using python-rbd which is not pip installable and is only available in
# packaged form.
#rm /var/lib/openstack/lib/python*/no-global-site-packages.txt
rm -rf /tmp/* /root/.cache /etc/machine-id
rm -rf /etc/yum.repos.d/*
rm -rf /opt/loci
find /usr/ /var/ \( -name "*.pyc" -o -name "__pycache__" \) -delete
