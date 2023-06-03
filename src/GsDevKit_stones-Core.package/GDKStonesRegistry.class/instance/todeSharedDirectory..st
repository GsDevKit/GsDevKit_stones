accessing
todeSharedDirectory: todeSharedDirPath
	"The tode shared directory is equivalent to the $GS_HOME/sys/local directory in GsDevKit_home"

	(todeSharedDirPath isKindOf: CharacterCollection)
		ifFalse: [ self error: 'The todeSharedDirectory is expected to be a CharacterCollection' ].
	todeSharedDirectory := todeSharedDirPath