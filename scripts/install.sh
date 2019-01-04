#!/bin/bash

set -ex

distro=$(awk -F= '/^ID=/ {gsub(/\"/, "", $2); print $2}' /etc/*release)
export distro=${DISTRO:=$distro}

if [[ "${PYTHON3}" == "no" ]]; then
    dpkg_python_packages=("python" "virtualenv")
    rpm_python_packages=("python" "python-virtualenv")
else
    dpkg_python_packages=("python3" "python3-virtualenv")
    rpm_python_packages=("python3" "python3-virtualenv")
fi

case ${distro} in
    debian|ubuntu)
        apt-get update
        apt-get upgrade -y
        apt-get install -y --no-install-recommends \
            git \
            ca-certificates \
            netbase \
            lsb-release \
            patch \
            sudo \
            ${dpkg_python_packages[@]}
        ;;
    centos)
        yum upgrade -y
        yum install -y --setopt=skip_missing_names_on_install=False \
            git \
            redhat-lsb-core \
            sudo \
        ;;
    opensuse|opensuse-leap|sles)
        if [[ "${PYTHON3}" == "no" ]]; then
           rpm_python_packages+=("python-devel" "python-setuptools")
        else
           rpm_python_packages+=("python3-devel" "python3-setuptools")
        fi
        zypper --non-interactive --gpg-auto-import-keys refresh
        zypper --non-interactive install --no-recommends \
            ca-certificates \
            git-core \
            lsb-release \
            patch \
            sudo \
            tar \
            ${rpm_python_packages[@]}
        #NOTE(evrardjp) Temporary workaround until bindep is fixed
        # for leap 15: https://review.openstack.org/#/c/586038/
        # should be merged and released.
        sed -i 's/ID="opensuse-leap"/ID="opensuse"/g' /etc/os-release
        ;;
    *)
        echo "Unknown distro: ${distro}"
        exit 1
        ;;
esac

if [[ "${PROJECT}" == "requirements" ]]; then
    $(dirname $0)/requirements.sh
    exit 0
fi

#$(dirname $0)/fetch_wheels.sh
#if [[ "${PROJECT}" == "infra" ]]; then
#   $(dirname $0)/setup_pip.sh
#    $(dirname $0)/pip_install.sh bindep ${PIP_PACKAGES}
#    $(dirname $0)/install_packages.sh
#    $(dirname $0)/cleanup.sh
#    exit 0
#fi
if [[ "${PLUGIN}" == "no" ]]; then
    $(dirname $0)/create_user.sh
fi

if [[ ${PROJECT} == 'nova' ]]; then
    $(dirname $0)/install_nova_console.sh
fi
$(dirname $0)/install_packages.sh
if [[ ${PROJECT} == 'keystone' ]] || [[ ${PROJECT} == 'nova' ]]; then
    $(dirname $0)/httpd_config.sh
fi
$(dirname $0)/cleanup.sh
