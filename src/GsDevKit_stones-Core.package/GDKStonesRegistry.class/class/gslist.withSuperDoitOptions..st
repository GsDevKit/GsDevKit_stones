runtime
gslist: superDoitScriptOrNil withSuperDoitOptions: superDoitOptionsBoolean
	"runs gslist and returns the output of gslist or error, if not able to run gslist"

	"if superDoitOptionsBoolean is true, then superDoitScriptOrNil is expected to respond to the following messages:
		long
		json
		gemstoneVersionString
		removeLocks"

	| stdout scriptPath exitStatus commandLine gslistOutput verbose long json removeLocks |
	verbose := GDKGsDevKit_stonesBase verbose.
	scriptPath := ' '.
	removeLocks := json := long := false.
	stdout := superDoitScriptOrNil
		ifNotNil: [ 
			scriptPath := ' (from ' , superDoitScriptOrNil scriptPath , ') '.
			superDoitOptionsBoolean
				ifTrue: [ 
					long := superDoitScriptOrNil long.
					json := superDoitScriptOrNil json.
					removeLocks := superDoitScriptOrNil removeLocks ].
			superDoitScriptOrNil stdout ]
		ifNil: [ GsFile stdout ].
	verbose
		ifTrue: [ 
			stdout
				lf;
				nextPutAll:
						'======  starting gslist at' , scriptPath , DateAndTime now printString;
				lf ].
	exitStatus := 0.
	commandLine := '$GEMSTONE/bin/gslist' asFileReference pathString.
	long
		ifTrue: [ commandLine add: ' -l' ].
	json
		ifTrue: [ commandLine add: ' -j' ].
	removeLocks
		ifTrue: [ commandLine add: ' -c' ].
	verbose
		ifTrue: [ 
			stdout
				lf;
				nextPutAll: commandLine;
				lf;
				yourself ].
	[ gslistOutput := GsHostProcess execute: commandLine ]
		on: ChildError
		do: [ :ex | 
			" Exit Status: 0 (OK)
						1 (No servers found)
						2 (Stale lock(s) removed)
						3, or 4  (Fatal error)"
			exitStatus := ex status ].
	exitStatus = 0
		ifTrue: [ 
			verbose
				ifTrue: [ stdout nextPutAll: gslistOutput	"stdout" ]
				ifFalse: [ ^ gslistOutput ] ]
		ifFalse: [ 
			exitStatus = 1
				ifTrue: [ 
					verbose
						ifTrue: [ stdout nextPutAll: 'no servers found (' , exitStatus printString , ')' ]
						ifFalse: [ ^ gslistOutput ] ]
				ifFalse: [ 
					exitStatus = 2
						ifTrue: [ 
							verbose
								ifTrue: [ stdout nextPutAll: 'stale locks removed (' , exitStatus printString , ')' ]
								ifFalse: [ ^ gslistOutput ] ]
						ifFalse: [ 
							exitStatus >= 3
								ifTrue: [ 
									verbose
										ifTrue: [ stdout nextPutAll: 'gslist failed to start (' , exitStatus printString , ')' ]
										ifFalse: [ self error: 'gslist failed to start(' , exitStatus printString , ')' ] ] ] ] ].
	verbose
		ifTrue: [ 
			stdout
				lf;
				nextPutAll: '****************************************';
				lf ]