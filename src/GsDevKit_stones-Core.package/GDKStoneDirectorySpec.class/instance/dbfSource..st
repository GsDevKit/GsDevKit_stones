accessing
dbfSource: stoneSpec
	"store dbfSource as String, for exporting as STON. Senders expect a file reference"
	
	^ (dbfSource
		ifNil: [ dbfSource := (stoneSpec gemstonePath asFileReference / 'bin' / 'extent0.dbf') asPathString ])
		asFileReference