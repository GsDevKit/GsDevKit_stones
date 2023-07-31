mount command
executeMountCommand: command batchMode: aBool
	"only one of --todeRoot of --serverRoot may be present"

	| index option commandLine todeRoot serverRoot rest |
	commandLine := command commandLine copy.
	todeRoot := '--todeRoot'.
	serverRoot := '--serverRoot'.
	(index := commandLine findString: todeRoot startingAt: 1) > 0
		ifTrue: [ option := todeRoot ]
		ifFalse: [ 
			(index := commandLine findString: serverRoot startingAt: 1) > 0
				ifTrue: [ option := serverRoot ] ].
	index > 0
		ifTrue: [ 
			| newCommandLine commandStream skipDone optionPath |
			"--todeRoot and --serverRoot options for mount command use a call back, so hard-wire 
				todeRoot/serverRoot path into the command and remove --todeRoot/--serverRoot 
				option from commandLine"
			newCommandLine := (commandLine copyFrom: 1 to: index - 1)
				, (commandLine copyFrom: index + option size to: commandLine size).
			commandStream := newCommandLine readStream.
			commandStream
				skipSeparators;
				skip: 'mount' size;
				skipSeparators;
				yourself.
			optionPath := option = todeRoot
				ifTrue: [ self sessionDescription serverTodeRoot ]
				ifFalse: [ 
					"fabricate the --stoneRoot path for the stone associated with session description"
					self sessionDescription serverTodeRoot.
					'/' , '/sys/stones/' , self sessionDescription stoneName ].
			newCommandLine := 'mount ' , optionPath.
			commandStream peek = $/
				ifFalse: [ 
					(optionPath endsWith: '/')
						ifFalse: [ newCommandLine add: '/' ] ].
			skipDone := false.
			[ skipDone ]
				whileFalse: [ 
					| char |
					"characters up to the next separator are part of first positional argument <directory-or-file-path>"
					(char := commandStream next) isSeparator
						ifTrue: [ skipDone := true ].
					newCommandLine add: char ].
			rest := commandStream upToEnd.
			newCommandLine add: rest.
			TDCommandLine
				fromStream: newCommandLine readStream
				forEachCommand: [ :newCommand | ^ self evaluateCommand: newCommand batchMode: aBool ] ]
		ifFalse: [ ^ self evaluateCommand: command batchMode: aBool ]