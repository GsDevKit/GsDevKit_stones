runtime
startStone: superDoitScriptOrNil
	| arrayOfOutputs stoneLogFile stdout scriptPath |
	stdout := superDoitScriptOrNil
		ifNotNil: [ 
			scriptPath := superDoitScriptOrNil scriptPath.
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
		logFile: stoneLogFile ]
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