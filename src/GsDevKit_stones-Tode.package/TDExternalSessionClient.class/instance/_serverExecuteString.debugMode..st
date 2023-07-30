server external session calls
_serverExecuteString: executeString debugMode: debugMode
	| doitString |
	doitString := debugMode
		ifTrue: [ 
			'
[ 
  ^ (' , executeString
				,
					') ]
    on: Error, Halt
    do: [ :ex | System waitForDebug ]' ]
		ifFalse: [ executeString ].
	[ self session nbExecute: doitString ]
		on: GsErrorNotification
		do: [ :ex | self error: 'Unable to execute #executeString: on tODE server' ].
	[ ^ self session nbResult ]
		on: GciError
		do: [ :ex | 
			ex gsNumber = 2336
				ifTrue: [ 
self halt. "need to make sure that we are using the client forwarder cache for look up"
					GsClientForwarderSendNotification new
						session: self;
						tag: ex gciErrSType;
						signal ] ]