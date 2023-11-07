instance creation
newRegistryNamed: registryName ensure: ensure
	| stonesRegistry stoneRegistry registryFile |
	stonesRegistry := self instance.
	stoneRegistry := (GDKStonesRegistry newNamed: registryName)
		parentRegistryName: registryName;
		parentRegistryPath:
				'$' , GDKGsDevKit_stonesBase dataHomeEnvVar , '/'
						,
							(self configFile relativeTo: GDKGsDevKit_stonesBase base_data_home) fullName;
		yourself.
	registryFile := stoneRegistry registryFile.
	registryFile exists
		ifTrue: [ 
			ensure
				ifTrue: [ ^ stonesRegistry at: registryName put: stoneRegistry registryPath ].
			self
				error: 'The registry named ' , registryName printString , ' already exists.' ].
	stonesRegistry at: registryName put: stoneRegistry registryPath.
	self configFile
		writeStreamDo: [ :fileStream | 
			(Rowan version >= '3.0.0' asRwSemanticVersionNumber
				or: [ self currentGemStoneVersion asRwGemStoneVersionNumber >= '3.7.0' ])
				ifTrue: [ fileStream truncate ].
			STON put: stonesRegistry onStreamPretty: fileStream ].
	stoneRegistry export.
	^ stoneRegistry