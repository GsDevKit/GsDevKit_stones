creation/destruction
destroyStoneStructure
	"destroy stone structure"

	"shut down stone BEFORE calling"

	(self waitStone: 1) ~= 3
		ifTrue: [ 
			self
				error:
					'The stone ' , self stoneName
						,
							' is still running. It must be stopped BEFORE destroying the stone structure' ].
	self rootDir exists
		ifTrue: [ self rootDir ensureDeleteAll ].
	self registryFile exists
		ifTrue: [ self registryFile ensureDelete ].
	self stoneDirectorySpec
		ifNotNil: [ :directorySpec | 
			"delete the todeShared stone reference AFTER deleting the stone directory (with symbolic link) ... see internal bug 50514"
			directorySpec destroyStoneStructure: self ]