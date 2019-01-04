FROM centos:latest

ENV PATH=/var/lib/openstack/bin:$PATH
ARG PROJECT
ARG WHEELS=loci/requirements:master-ubuntu
ARG PROJECT_REF=master
ARG DISTRO
ARG PROFILES
ARG PIP_PACKAGES=""
ARG PIP_ARGS=""
ARG DIST_PACKAGES=""
ARG PLUGIN=no
ARG PYTHON3=no
ARG OPG

ARG UID=42424
ARG GID=42424

ARG NOVNC_REPO=https://github.com/novnc/novnc
ARG NOVNC_REF=v1.0.0
ARG SPICE_REPO=https://gitlab.freedesktop.org/spice/spice-html5.git
ARG SPICE_REF=spice-html5-0.1.6

COPY scripts /opt/loci/scripts
COPY ceph_stable.repo epel.repo openstack-rock.repo qemu-kvm.repo /etc/yum.repos.d/ 

RUN /opt/loci/scripts/install.sh
ENV TZ=Asia/Shanghai 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
