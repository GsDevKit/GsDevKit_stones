start/stop
startStone: superDoitScript
	| arrayOfOutputs |
	superDoitScript stdout
		lf;
		nextPutAll:
				'======  ' , superDoitScript scriptPath , ' starting stone at '
						, DateAndTime now printString;
		lf;
		lf.
	arrayOfOutputs := (Rowan globalNamed: 'GsStartStone')
		startStone: self stoneName
		exeConfFile: self sysConfFile pathString
		logFile: (self rootDir / self stoneDirectorySpec logs / self stoneName , 'log') pathString.
	superDoitScript stdout nextPutAll: (arrayOfOutputs at: 1).	"stdout"
	superDoitScript stdout
		nextPutAll: '****************************************';
		lf