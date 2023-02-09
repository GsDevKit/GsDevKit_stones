accessing
hostName
	^ (GsHostProcess execute: '/bin/hostname') trimWhiteSpace