server external session calls
_serverEffectiveApiVersion: versionString to: topezServerOop
	| doitString |
	doitString := '
[ 
  | tsp |
  tsp := Object _objectForOop: ' , topezServerOop printString
		,
			'.
  tsp effectiveApiVersion: ' , versionString printString
		,
			' ]
    on: Error
    do: [ :ex | System waitForDebug ]'.
	[ self session nbExecute: doitString ]
		on: GsErrorNotification
		do: [ :ex | self error: 'Unable send #effectiveApiVersion: message to tODE server' ].
	^ self session nbResult