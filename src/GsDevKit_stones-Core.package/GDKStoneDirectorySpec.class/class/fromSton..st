instance creation
fromSton: stonReader
	"Bypass instance initialize when reading from STON file ... "
	
	^ self basicNew
		fromSton: stonReader;
		yourself