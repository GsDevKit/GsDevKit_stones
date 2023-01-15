initialization
initialize
	| stoneDirTemplate |
	super initialize.
	sessions := Dictionary new.
	templates := Dictionary new.
	projectSets := Dictionary new.
	stones := Dictionary new.
	stoneDirTemplate := GDK_stonesStoneDirectorySpec newNamed: 'default'.
	stoneDirTemplate registryFile exists
		ifFalse: [ 
			stoneDirTemplate export.
			templates at: 'default' put: stoneDirTemplate registryPath ]