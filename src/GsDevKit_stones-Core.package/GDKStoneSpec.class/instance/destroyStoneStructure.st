creation/destruction
destroyStoneStructure
	"destroy stone structure"

	"need to make sure that stone and netldi are shut down, for now delete stone directory and registry file"

	self rootDir exists
		ifTrue: [ self rootDir ensureDeleteAll ].
	self registryFile exists
		ifTrue: [ self registryFile ensureDelete ]