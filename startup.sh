#!/bin/sh

CGIT_VARS='$CGIT_TITLE:$CGIT_DESC:$CGIT_VROOT:$CGIT_SECTION_FROM_STARTPATH'

envsubst "$CGIT_VARS" < /etc/cgitrc.template > /etc/cgitrc

apachectl -DFOREGROUND
