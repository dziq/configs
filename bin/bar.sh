#!/bin/sh
 
print_date() {
  # The date is printed to the status bar by default.
  # To print the date through this script, set clock_enabled to 0
  # in scrotwm.conf. Uncomment "print_date" below.
  FORMAT="%a %b %d %R %Z %Y"
  DATE=`date "+${FORMAT}"`
  echo -n "${DATE} "
}
 
