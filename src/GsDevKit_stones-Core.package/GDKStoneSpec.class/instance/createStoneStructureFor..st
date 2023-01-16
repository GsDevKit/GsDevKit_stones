creation/destruction
createStoneStructureFor: stonesRegistry
	"create stone"

	self rootDir ensureCreateDirectory.
	stonesRegistry productNamed: self gemstoneVersionString.
"populate the rootDir< etc"