server external session calls
_serverSnapshotDirectory: snapshotDirectoryString to: topezServerOop
	| doitString |
	doitString := '
[ 
  | tsp |
  tsp := Object _objectForOop: ' , topezServerOop printString
		,
			'.
  tsp snapshotDirectory: ' , snapshotDirectoryString printString
		,
			' ]
    on: Error
    do: [ :ex | System waitForDebug ]'.
	[ self session nbExecute: doitString ]
		on: GsErrorNotification
		do: [ :ex | self error: 'Unable send #snapshotDirectory: message to tODE server' ].
	^ self session nbResult