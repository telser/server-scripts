#!/bin/sh
/usr/pkg/bin/tarsnap -c -f "$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)" --print-stats /etc /usr/pkg/etc
