accessing
todeHome: todeHomeDirPath
	"The tode home is equivalent to the $GS_HOME directory in GsDevKit_home"

	(todeHomeDirPath isKindOf: CharacterCollection)
		ifFalse: [ self error: 'The todeHome is expected to be a CharacterCollection' ].
	todeHome := todeHomeDirPath