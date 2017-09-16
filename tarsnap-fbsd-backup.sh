#!/bin/sh
/usr/local/bin/tarsnap -c -f "$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)" --print-stats /etc /usr/local/etc
