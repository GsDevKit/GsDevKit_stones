accessing
dbfSource: stoneSpec
	^ (dbfSource
		ifNil: [ dbfSource := stoneSpec gemstonePath asFileReference / 'bin' / 'extent0.dbf' ])
		asFileReference