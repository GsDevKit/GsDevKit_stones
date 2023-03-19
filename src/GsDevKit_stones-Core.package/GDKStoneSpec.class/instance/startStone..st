runtime
startStone: superDoitScript
	| arrayOfOutputs stoneLogFile |
	superDoitScript stdout
		lf;
		nextPutAll:
				'======  ' , superDoitScript scriptPath , ' starting stone at '
						, DateAndTime now printString;
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
			superDoitScript stdout
				nextPutAll: stoneLog contents;
				lf.
			superDoitScript stdout
				nextPutAll: '****************************************';
				lf.
			^ self ].
	superDoitScript stdout nextPutAll: (arrayOfOutputs at: 1).	"stdout"
	superDoitScript stdout
		nextPutAll: '****************************************';
		lf