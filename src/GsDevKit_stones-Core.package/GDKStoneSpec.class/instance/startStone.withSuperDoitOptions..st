runtime
startStone: superDoitScriptOrNil withSuperDoitOptions: superDoitOptionsBoolean
	"if superDoitOptionsBoolean is true, then superDoitScriptOrNil is expected to respond to the following messages:
		restart
		conversion
		notranlogs
		restore"

	| arrayOfOutputs stoneLogFile stdout scriptPath notranlogsMode restorMode |
	notranlogsMode := restorMode := false.
	stdout := superDoitScriptOrNil
		ifNotNil: [ 
			scriptPath := superDoitScriptOrNil scriptPath.
			superDoitOptionsBoolean
				ifTrue: [ 
					notranlogsMode := superDoitScriptOrNil notranlogs.
					restorMode := superDoitScriptOrNil restore ].
			superDoitScriptOrNil stdout ]
		ifNil: [ 
			scriptPath := ''.
			GsFile stdout ].
	stdout
		lf;
		nextPutAll:
				'======  ' , scriptPath , ' starting stone at ' , DateAndTime now printString;
		lf;
		lf.
	self defineCustomEnvVars.
	stoneLogFile := (self rootDir / self stoneDirectorySpec logs / self stoneName
		, 'log') pathString.
	[ 
	arrayOfOutputs := (Rowan globalNamed: 'GsStartStone')
		startStone: self stoneName
		exeConfFile: self sysConfFile pathString
		sysConfFile: self sysConfFile pathString
		logFile: stoneLogFile
		noTranlogs: notranlogsMode
		restoreMode: restorMode
		conversionMode: false ]
		on: ChildError
		do: [ :ex | 
			| stoneLog |
			stoneLog := stoneLogFile asFileReference.
			stoneLog exists
				ifFalse: [ ^ ex pass ].
			stdout
				nextPutAll: stoneLog contents;
				lf.
			stdout
				nextPutAll: '****************************************';
				lf.
			^ self error: 'Stone did not start' ].
	stdout nextPutAll: (arrayOfOutputs at: 1).	"stdout"
	stdout
		nextPutAll: '****************************************';
		lf