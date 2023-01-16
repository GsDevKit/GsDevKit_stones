instance creation
newNamed: stoneName rootDirectory: rootDirPath directorySpecName: directorySpecName gemstoneVersionString: gemstoneVersionString
	^ (self newNamed: stoneName)
		root: rootDirPath asFileReference pathString;
		stoneName: stoneName;
		stoneDirectorySpecName: directorySpecName;
		gemstoneVersionString: gemstoneVersionString;
		yourself