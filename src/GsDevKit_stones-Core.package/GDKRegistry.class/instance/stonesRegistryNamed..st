accessing
stonesRegistryNamed: registryName
	| registryPath |
	registryPath := self
		at: registryName
		ifAbsent: [ self error: 'No registry named ' , registryName printString ].