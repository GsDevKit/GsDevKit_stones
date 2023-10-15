runtime
stopNetldi: superDoitScriptOrNil withSuperDoitOptions: superDoitOptionsBoolean
	"if superDoitOptionsBoolean is true, then superDoitScriptOrNil is expected to respond to the following messages:
		debugLogging
		restart"

	| scriptPath stdout exitStatus commandLine arrayOfOutputs |
	scriptPath := ''.
	stdout := superDoitScriptOrNil
		ifNotNil: [ 
			scriptPath := superDoitScriptOrNil scriptPath.
			superDoitScriptOrNil stdout ]
		ifNil: [ GsFile stdout ].
	stdout
		lf;
		nextPutAll: '======  stopping netldi at ' , DateAndTime now printString;
		lf.
	exitStatus := 0.
	self defineCustomEnvVars.
	commandLine := '$GEMSTONE/bin/stopnetldi' asFileReference fullName.
	commandLine
		add: ' ' , self stoneName , '_ldi';
		yourself.
	GDKGsDevKit_stonesBase verbose
		ifTrue: [ 
			stdout
				lf;
				nextPutAll: commandLine;
				yourself ].
	[ arrayOfOutputs := GsHostProcess execute: commandLine ]
		on: ChildError
		do: [ :ex | 
			"exit status:
				0 on successful stop
				1 if the specified netldi was not running
				3 or above, an error occurred and the specified netldi could not be stopped"
			exitStatus := ex status.
			stdout
				nextPutAll: ex stderr;
				lf ].
	exitStatus = 0
		ifTrue: [ stdout nextPutAll: (arrayOfOutputs at: 1)	"stdout" ]
		ifFalse: [ 
			exitStatus = 1
				ifTrue: [ stdout nextPutAll: 'netldi was not running (' , exitStatus printString , ')' ]
				ifFalse: [ 
					exitStatus >= 3
						ifTrue: [ 
							stdout
								nextPutAll:
									'netldi could not be stopped (' , exitStatus printString , ')' ] ] ].
	stdout
		lf;
		nextPutAll: '****************************************';
		lf