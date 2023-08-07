runtime
stopStone: superDoitScriptOrNil withSuperDoitOptions: superDoitOptionsBoolean timeout: timeoutDefault immediate: immediateDefault
	| exitStatus arrayOfOutputs stdout scriptPath immediate timeout |
	scriptPath := ''.
	immediate := immediateDefault.
	timeout := timeoutDefault.
	stdout := superDoitScriptOrNil
		ifNotNil: [ 
			scriptPath := superDoitScriptOrNil scriptPath.
			superDoitScriptOrNil timeout ifNotNil: [ :value | timeout := value asNumber ].
			immediate := superDoitScriptOrNil immediate.
			superDoitScriptOrNil stdout ]
		ifNil: [ GsFile stdout ].
	stdout
		lf;
		nextPutAll:
				'======  ' , scriptPath , ' stopping stone at ' , DateAndTime now printString;
		lf;
		lf.
	exitStatus := 0.
	self defineCustomEnvVars.
	[ 
	arrayOfOutputs := (Rowan globalNamed: 'GsStopStone')
		stopStone: self stoneName
		userName: self userId
		password: self password
		timeout: timeout
		immediate: immediate ]
		on: ChildError
		do: [ :ex | 
			" stopstone exit status:
               * 0 (success) Successful stop
               * 1 (informational) No running stone with that stonename
               * 2 (warning)
               * 3 or above (error) an error occurred and the specified stone was not stopped.
               * 10 syntax error
               * 11 bad user or password
               * 12 specified user does not have privilege to stop the stone.
               * 13 stone not stopped; other users logged in. Use -i to override."
			exitStatus := ex status ].
	exitStatus = 0
		ifTrue: [ stdout nextPutAll: (arrayOfOutputs at: 1)	"stdout" ]
		ifFalse: [ 
			exitStatus = 1
				ifTrue: [ 
					stdout
						nextPutAll: 'No running stone with the name ' , self stoneName printString;
						lf ]
				ifFalse: [ 
					exitStatus = 2
						ifTrue: [ 
							stdout
								nextPutAll: 'warning ';
								lf ]
						ifFalse: [ 
							(exitStatus >= 3 and: [ exitStatus <= 9 ])
								ifTrue: [ 
									stdout
										nextPutAll: 'Stone not stopped';
										lf ]
								ifFalse: [ 
									exitStatus = 10
										ifTrue: [ 
											stdout
												nextPutAll: 'Syntax error. Stone not stopped';
												lf ]
										ifFalse: [ 
											exitStatus = 11
												ifTrue: [ 
													stdout
														nextPutAll: 'Bad user or password. Stone not stopped';
														lf ]
												ifFalse: [ 
													exitStatus = 12
														ifTrue: [ 
															stdout
																nextPutAll:
																		'Specified user does not have privilege to stop the stone. Stone not stopped';
																lf ]
														ifFalse: [ 
															exitStatus = 13
																ifTrue: [ 
																	stdout
																		nextPutAll:
																				'other users logged in. Use -i to override Stone not stopped';
																		lf ] ] ] ] ] ] ].
			self error: 'Stone not stopped' ].
	stdout
		nextPutAll: '****************************************';
		lf