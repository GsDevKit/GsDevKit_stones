creation/destruction
createStoneStructureUsing: stonesRegistry
	"create stone"

	self rootDir ensureCreateDirectory.
	stonesRegistry productNamed: self gemstoneVersionString.
	(GDKAbstractRegistryStore
		fromPath: (stonesRegistry templateNamed: self stoneDirectorySpecName)
		ifAbsent: [  ]) createStoneStructure: self	"populate directory structure"