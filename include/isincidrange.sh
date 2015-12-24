#!/bin/sh
##############################################################################
#
# Copyright 2015 spf-tools team (see AUTHORS)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#
##############################################################################
#
# Usage: $BNAME <ip> <ip> <mask>
# E.g.: $BNAME 192.168.0.1 192.168.0.5 24

a="/$0"; a=${a%/*}; a=${a#/}; a=${a:-.}; BINDIR=$(cd $a; pwd)
export PATH=$BINDIR:$PATH

IP1=${1:-'193.87.44.98'}
IP2=${2:-'8.8.4.4'}
MSK=${3:-'24'}

bece() {
  bc <<EOF
obase=2
$1
EOF
}

#echo isincidrange.sh $IP1 $IP2 $MSK 1>&2
: Input is contained in the CIDR range
test "$IP1" = "$IP2" && exit 0

if
  test $MSK -gt 8
then
  firstA=${IP1%%.*}
  restA=${IP1#*.}
  firstB=${IP2%%.*}
  restB=${IP2#*.}
  mask=$((MSK-8))
  test $firstA -eq $firstB && exec isincidrange.sh $restA $restB $mask
else
  firstA=$(bece ${IP1%%.*} | cut -b-$MSK)
  firstB=$(bece ${IP2%%.*} | cut -b-$MSK)
  test $firstA -eq $firstB && exit 0
fi

: Input is not contained in the CIDR range
exit 1
