runtime
waitStone: timeout
	"return exit status of waitstone command"

	| exitStatus |
	exitStatus := 0.
	[ 
	(Rowan globalNamed: 'GsWaitStone')
		waitForStoneName: self stoneName
		timeout: timeout ]
		on: ChildError
		do: [ :ex | 
			" stopstone exit status:
        		0 if the server (netldi or stone) is ready,
        		1 if the server is already already servicing the maximum number of sessions,
        		2 if the server is rejecting connections during startup or shutdown,
        		3 if the server was not found."
			exitStatus := ex status ].
	^ exitStatus