scripts
createStone: stonesRootDir stonesRegistry: stonesRegistry stoneName: stoneName stoneDirectoryTemplate: templateName gemstoneVersion: gemstoneVersionString force: force script: scriptOrNil
	| stoneSpec basename |
	basename := scriptOrNil
		ifNil: [ '' ]
		ifNotNil: [ :script | ' (' , script basename , ')' ].
	stoneSpec := GDKStoneSpec
		newNamed: stoneName
		rootDirectory: stonesRootDir / stoneName
		directorySpecName: templateName
		gemstoneVersionString: gemstoneVersionString.
	stoneSpec
		parentRegistryName: stonesRegistry parentRegistryName;
		parentRegistryPath:
				'$' , GDKGsDevKit_stonesBase dataHomeEnvVar , '/'
						,
							(stonesRegistry registryFile relativeTo: stonesRegistry class base_data_home)
								fullName;
		yourself.
	stoneSpec registryFile exists
		ifTrue: [ 
			force
				ifFalse: [ 
					self
						error:
							'A stone named ' , stoneName , ' already exists. Use --force to clean up.'
								, basename ].
			stonesRegistry destroyStoneStructureFor: stoneName ]
		ifFalse: [ 
			stoneSpec rootDir exists
				ifTrue: [ 
					force
						ifTrue: [ stoneSpec rootDir ensureDeleteAll ]
						ifFalse: [ 
							self
								error:
									'The directory ' , stoneSpec rootDir fullName
										, ' already exists. Use --force to clean up.' , basename ] ] ].
	stoneSpec createStoneStructureUsing: stonesRegistry.
	stoneSpec registryDir ensureCreateDirectory.
	stoneSpec export.
	stonesRegistry stones at: stoneName put: stoneSpec registryPath.
	stonesRegistry export.
	stoneSpec class
		symbolicLink: stoneSpec registryPath
		linkName: stoneSpec rootDir / '.GDKStoneSpec.ston'.
	^ stoneSpec