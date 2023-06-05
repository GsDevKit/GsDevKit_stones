stone creation
createTodeHomeDirectory: stoneSpec
	stoneSpec todeHome
		ifNil: [ 
			GsFile stdout
				nextPutAll:
					'WARNING: tode home directory is not defined, use registerTodeSharedDirectory.solo to define' ]
		ifNotNil: [ :todeHome | 
			| todeStonesDir |
			todeStonesDir := todeHome asFileReference / 'sys' / 'local' / 'server' / 'stones'
				/ stoneSpec stoneName.
			todeStonesDir ensureCreateDirectory.
			self class symbolicLink: todeStonesDir linkName: stoneSpec rootDir / 'tode'.
			self createTodeStoneMetadata: todeStonesDir.
			self createSessionDescripton: stoneSpec ]