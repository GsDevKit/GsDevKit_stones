server external session calls
_serverExecuteString: executeString
	| doitString |
	doitString := '
[ 
  ^ (' , executeString 
		,
			') ]
    on: Error, Halt
    do: [ :ex | System waitForDebug ]'.
	[ self session nbExecute: doitString ]
		on: GsErrorNotification
		do: [ :ex | self error: 'Unable to execute #executeString: on tODE server' ].
	^ self session nbResult