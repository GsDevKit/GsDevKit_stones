runtime
startNetldi: superDoitScriptOrNil withSuperDoitOptions: superDoitOptions
	"nothing special with regards to options at the present time"

	| scriptPath stdout exitStatus commandLine arrayOfOutputs |
	scriptPath := ''.
	stdout := superDoitScriptOrNil
		ifNotNil: [ 
			scriptPath := superDoitScriptOrNil scriptPath.
			superDoitScriptOrNil stdout ]
		ifNil: [ GsFile stdout ].
	stdout
		lf;
		nextPutAll: '======  starting netldi at ' , DateAndTime now printString;
		lf.
	exitStatus := 0.
	self defineCustomEnvVars.
	commandLine := '$GEMSTONE/bin/startnetldi' asFileReference pathString.
	commandLine
		add: ' -g';
		add: ' -a ' , (System gemEnvironmentVariable: 'USER');
		add: ' -P ' , self stoneDirectorySpec netldiPort asString;
		add: ' -l ' , (self logsDir / 'netldi.log') pathString;
		add: ' ' , self stoneName , '_ldi';
		yourself.
	[ arrayOfOutputs := GsHostProcess execute: commandLine ]
		on: ChildError
		do: [ :ex | 
			"exit status:
				0 on successful start
				1 if the specified netldi is already running
				2 if already running but the executable have been deleted
				3 or above, an error occurred and the specified netldi was not started"
			exitStatus := ex status ].
	exitStatus = 0
		ifTrue: [ stdout nextPutAll: (arrayOfOutputs at: 1)	"stdout" ]
		ifFalse: [ 
			(exitStatus = 1 or: [ exitStatus = 2 ])
				ifTrue: [ stdout nextPutAll: 'netldi is already running' ]
				ifFalse: [ 
					exitStatus >= 3
						ifTrue: [ stdout nextPutAll: 'netldi failed to start' ] ] ].
	stdout
		lf;
		nextPutAll: '****************************************';
		lf