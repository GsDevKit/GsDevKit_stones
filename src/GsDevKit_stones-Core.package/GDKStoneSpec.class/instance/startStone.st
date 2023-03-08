start/stop
startStone
	| arrayOfOutputs |
	self stdout
		lf;
		nextPutAll:
				'======  ' , self scriptPath , ' starting stone at '
						, DateAndTime now printString;
		lf;
		lf.
	arrayOfOutputs := (Rowan globalNamed: 'GsStartStone')
		startStone: self stoneName
		exeConfFile: self sysConfFile pathString.
	self stdout nextPutAll: (arrayOfOutputs at: 1).	"stdout"
	self stdout
		nextPutAll: '****************************************';
		lf