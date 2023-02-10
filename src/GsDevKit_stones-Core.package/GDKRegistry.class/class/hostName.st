accessing
hostName
	^ (GsHostProcess execute: '/usr/bin/hostname') trimWhiteSpace