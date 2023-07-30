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
	[ | x |
x := self session nbResult.
self halt. " never get here"]
		on: GciError
		do: [ :ex | 
			ex gsNumber = 2336
				ifTrue: [ 
					"going to ignore client forwarders at the moment ... from a solo session, there's not much of a client floating around"
					false
						ifTrue: [ 
							GsClientForwarderSendNotification new
								session: self;
								tag: ex gciErrSType;
								signal ].
self halt.
ex continue. "after this continue, lastResult is the string we are looking for, however, the continue is necessary and we end up returning something different"
 ] ]