#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

log $0 starting
true || fat $0 failed
log $0 stopping
