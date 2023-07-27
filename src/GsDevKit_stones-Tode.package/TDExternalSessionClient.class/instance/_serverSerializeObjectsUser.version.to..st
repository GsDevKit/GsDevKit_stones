server external session calls
_serverSerializeObjectsUser: serializerClassString version: versionString to: topezServerOop
	| doitString |
	doitString := '
[ 
  | tsp |
  tsp := Object _objectForOop: ' , topezServerOop printString
		,
			'.
  tsp serializeObjectsUsing: ' , serializerClassString printString
		, ' version: ' , versionString printString
		,
			' ]
    on: Error
    do: [ :ex | System waitForDebug ]'.
	[ self session nbExecute: doitString ]
		on: GsErrorNotification
		do: [ :ex | self error: 'Unable send #serializeObjectsUsing:version: message to tODE server' ].
	^ self session nbResult