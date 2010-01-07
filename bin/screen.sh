#!/bin/bash
# Author: Martin Dengler <martin at martindengler.com>
# idea from http://www.mail-archive.com/screen-users@gnu.org/msg00322.html
# based on battery info from olpc-logbat
echo `hal-device | grep charge_level.percentage | awk '{print $3}'`%
