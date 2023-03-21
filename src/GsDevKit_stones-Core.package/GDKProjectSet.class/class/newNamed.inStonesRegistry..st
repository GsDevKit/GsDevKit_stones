instance creation
newNamed: aName inStonesRegistry: stonesRegistry
	^ (super newNamed: aName)
		parentRegistryName: stonesRegistry parentRegistryName;
		parentRegistryPath: stonesRegistry parentRegistryPath;
		yourself