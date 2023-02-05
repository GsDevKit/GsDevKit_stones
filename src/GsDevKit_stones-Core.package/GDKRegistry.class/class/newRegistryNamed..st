instance creation
newRegistryNamed: registryName
	| stonesRegistry stoneRegistry registryFile |
	stonesRegistry := self instance.
	stoneRegistry := (GDKStonesRegistry newNamed: registryName)
		parentRegistryName: registryName;
		parentRegistryPath:
				'$XDG_DATA_HOME/'
						, (self configFile relativeTo: GDK_XDGBase data_home) pathString;
		yourself.
	registryFile := stoneRegistry registryFile.
	registryFile exists
		ifTrue: [ 
			self
				error: 'The registry named ' , registryName printString , ' already exists.' ].
	stonesRegistry at: registryName put: stoneRegistry registryPath.
	self configFile
		writeStreamDo: [ :fileStream | STON put: stonesRegistry onStreamPretty: fileStream ].
	stoneRegistry export.
	^ stoneRegistry