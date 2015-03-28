#!/bin/bash
result=$(/bin/ls -alh /mnt/rsync.net \
			| /usr/bin/awk 'NR>1 {print "{ \"Name\": \"" $9"\", \"user\": \""$3"\", \"group\": \""$4"\", \"used\": \""$4"\", \"size\": \""$5"\"}," }'
		)
echo [ ${result%?} ]

