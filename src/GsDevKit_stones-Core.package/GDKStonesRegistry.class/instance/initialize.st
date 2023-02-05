initialization
initialize
	| projectRoot |
	super initialize.
	sessions := Dictionary new.
	templates := Dictionary new.
	projectSets := Dictionary new.
	products := Dictionary new.
	stones := Dictionary new.
	projectRoot := (Rowan projectNamed: 'GsDefKit_stones') repositoryRoot
		asFileReference / 'templates'.
	projectRoot allFiles
		do: [ :file | 
			"populate the templates directory from the GsDevKit_stones templates directory"
			file extension = 'ston'
				ifTrue: [ 
					| stoneDirTemplate |
					stoneDirTemplate := GDKstonesStoneDirectorySpec
						fromPath: file
						ifAbsent: [  ].
					stoneDirTemplate registryFile exists
						ifFalse: [ stoneDirTemplate export ].
					templates at: stoneDirTemplate name put: stoneDirTemplate registryPath ] ]