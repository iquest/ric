#!/bin/bash

#
# Publish all RIC gems to rubygems server
#

# Number of arguments
if [ "$#" != "0" ]; then
	echo "Usage: $0"
	exit 1
fi

# Basic setting
script_dir="`cd \"\`dirname \\\"$0\\\"\`\"; pwd`"
root_dir="$script_dir/.."
build_dir="$root_dir/build"

# Install all engines
for engine in ric_account ric_admin ric_advert ric_assortment ric_customer ric_devise ric_eshop ric_magazine ric_newsletter ric_rolling ric_user ric_website; do
	gem inabox "$build_dir"/"$engine"-*
done