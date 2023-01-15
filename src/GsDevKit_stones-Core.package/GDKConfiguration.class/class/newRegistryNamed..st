instance creation
newRegistryNamed: registryName
	| configuration stoneRegistry registryFile |
	configuration := self instance.
	stoneRegistry := (GDKStonesRegistry newNamed: registryName)
		parentRegistryName: registryName;
		parentRegistryPath:
				'$XDG_CONFIG_HOME/'
						, (self configFile relativeTo: GDK_XDGBase config_home) pathString;
		yourself.
	registryFile := stoneRegistry registryFile.
	registryFile exists
		ifTrue: [ 
			self
				error: 'The registry named ' , registryName printString , ' already exists.' ].
	configuration at: registryName put: stoneRegistry registryPath.
	self configFile
		writeStreamDo: [ :fileStream | STON put: configuration onStreamPretty: fileStream ].
	stoneRegistry export.
	^ stoneRegistry