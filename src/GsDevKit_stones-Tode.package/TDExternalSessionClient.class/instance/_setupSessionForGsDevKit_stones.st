private
_setupSessionForGsDevKit_stones
	"set up the tODE for GsDevKit_stones environment. session has been logged in, so we can 
		execute commands and set up environement:
			1. set gitRootPath
	"

	| executeString doitString |
	executeString := 'TDProjectEntryDefinition defaultGitRootPath: '
		, self sessionDescription serverGitRoot printString.
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
		do: [ :ex | self error: 'Unable send #backupDirectory: message to tODE server' ].
	^ self session nbResult