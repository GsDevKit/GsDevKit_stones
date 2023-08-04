creation/destruction
createStoneStructureUsing: stonesRegistry
	"create stone"

	| stoneDirSpec |
	self rootDir ensureCreateDirectory.
	[ 
	stonesRegistry productNamed: self gemstoneVersionString.
	stoneDirSpec := GDKAbstractRegistryStore
		fromPath: (stonesRegistry templateNamed: self stoneDirectorySpecName)
		ifAbsent: [  ].
	self stoneDirectorySpec: stoneDirSpec.
	stoneDirSpec createStoneStructure: self	"populate directory structure" ]
		on: Error
		do: [ :ex | 
			self rootDir deleteAll.
			ex pass ]