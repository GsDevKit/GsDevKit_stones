server external session calls
_serverBackupDirectory: backupDirectoryString to: topezServerOop
	| doitString |
	doitString := '
[ 
  | tsp |
  tsp := Object _objectForOop: ' , topezServerOop printString
		,
			'.
  tsp backupDirectory: ' , backupDirectoryString printString
		,
			' ]
    on: Error
    do: [ :ex | System waitForDebug ]'.
	[ self session nbExecute: doitString ]
		on: GsErrorNotification
		do: [ :ex | self error: 'Unable send #backupDirectory: message to tODE server' ].
	^ self session nbResult