creation/destruction
createStoneStructure
	"create stone"

	| stonesRegistry gemstoneProduct |
	stonesRegistry := GDKAbstractRegistryStore
		fromPath: self parentRegistryPath
		ifAbsent: [ 
			self
				error:
					'cannot find parent registry ' , self parentRegistryName , ' at  '
						, self parentRegistryPath printString ].
	self rootDir ensureCreateDirectory.
	gemstoneProduct := stonesRegistry productNamed: self gemstoneVersionString