#!/bin/bash

set -ex

#if [[ "${PYTHON3}" != "no" ]]; then
#    python3=python3
#fi

#PACKAGES=($(bindep -f /opt/loci/bindep.txt -b -l newline ${PROJECT} ${PROFILES} ${python3} || :))

#if [[ ! -z ${PACKAGES} ]]; then
#    case ${distro} in
#        debian|ubuntu)
#            apt-get install -y --no-install-recommends ${PACKAGES[@]} ${DIST_PACKAGES}
#            ;;
#        centos)
#            #yum -y --setopt=skip_missing_names_on_install=False install ${PACKAGES[@]} ${DIST_PACKAGES}
#            yum -y --setopt=skip_missing_names_on_install=False install ${OPG} 
#            ;;
#       opensuse|opensuse-leap|sles)
#            zypper --non-interactive install --no-recommends ${PACKAGES[@]} ${DIST_PACKAGES}
#            ;;
#        *)
#            echo "Unknown distro: ${distro}"
#            exit 1
#            ;;
#    esac
#fi
yum -y --setopt=skip_missing_names_on_install=False install yum-plugin-priorities
yum -y --setopt=skip_missing_names_on_install=False install ${OPG} 
