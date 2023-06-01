accessing
registry
	^ GDKAbstractRegistryStore
		fromPath: self parentRegistryPath
		ifAbsent: [ self error: 'Registry not found at ' , self parentRegistryPath printString ]