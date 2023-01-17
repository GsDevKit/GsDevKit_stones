creation/destruction
createStoneStructure
	"create stone"

	| stonesRegistry |
	stonesRegistry := self stonesRegistry.
	self rootDir ensureCreateDirectory.

	stonesRegistry productNamed: self gemstoneVersionString.
	(stonesRegistry templateNamed: self stoneDirectorySpecName)
		createStoneStructure: self