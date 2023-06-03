stone creation
createTodeSharedDirectory: stoneSpec
	stoneSpec todeSharedDirectory
		ifNil: [ 
			GsFile stdout
				nextPutAll:
					'WARNING: tode shared directory is not defined, use registerTodeSharedDirectory.solo to define' ]
		ifNotNil: [ :todeSharedDirectory | 
			| todeDir |
			todeDir := todeSharedDirectory asFileReference / 'server' / 'stones'
				/ stoneSpec stoneName.
			todeDir ensureCreateDirectory.
			self class symbolicLink: todeDir linkName: stoneSpec rootDir / 'tode'.
			self createTodeStoneMetadata: stoneSpec.
			self createSessionDescripton: stoneSpec ]