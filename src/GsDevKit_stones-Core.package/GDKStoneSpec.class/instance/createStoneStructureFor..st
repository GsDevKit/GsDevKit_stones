creation/destruction
createStoneStructureFor: stonesRegistry
	"create stone"

	| productPath |
	self rootDir ensureCreateDirectory.
	productPath := stonesRegistry productNamed: self gemstoneVersionString	
"populate the rootDir< etc"