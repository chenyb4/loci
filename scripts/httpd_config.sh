#!/bin/bash

set -ex

FILE=/etc/httpd/conf/httpd.conf

if [ -e $FILE ];then
    sed -i -r 's,^(Listen 80),#\1,' $FILE
fi
