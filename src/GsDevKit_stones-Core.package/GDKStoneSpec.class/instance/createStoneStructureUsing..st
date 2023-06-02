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
	stoneDirSpec createStoneStructure: self.	"populate directory structure"
	self stoneDirectorySpec: stoneDirSpec ]
		on: Error
		do: [ :ex | self rootDir deleteAllChildren ]