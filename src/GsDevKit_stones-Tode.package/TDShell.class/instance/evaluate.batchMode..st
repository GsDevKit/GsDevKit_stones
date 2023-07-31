evaluator engine
evaluate: aString batchMode: aBool
	[ 
	| result |
	TDCommandLine
		fromStream: aString readStream
		selectLine: [ :line | true ]
		forEachCommand: [ :command | 
			| index commandLine todeRoot rest |
			commandLine := command commandLine copy.
			todeRoot := '--todeRoot'.
			(command command = 'mount'
				and: [ (index := commandLine findString: todeRoot startingAt: 1) > 0 ])
				ifTrue: [ 
					| newCommandLine commandStream skipDone |
					"--todeRoot option for mount command uses a call back, so hard-wire todeRoot path into the command 
						and remove --todeRoot option from commandLine"
					newCommandLine := (commandLine copyFrom: 1 to: index - 1)
						, (commandLine copyFrom: index + todeRoot size to: commandLine size).
					commandStream := newCommandLine readStream.
					commandStream
						skipSeparators;
						skip: 'mount' size;
						skipSeparators;
						yourself.
					newCommandLine := 'mount ' , self sessionDescription serverTodeRoot.
					commandStream peek = $/
						ifFalse: [ 
							(self sessionDescription serverTodeRoot endsWith: '/')
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
						forEachCommand: [ :newCommand | result := self evaluateCommand: newCommand batchMode: aBool ] ]
				ifFalse: [ result := self evaluateCommand: command batchMode: aBool ] ].
	^ result ]
		on: Error , TDRestoreFromBackupComplete , GsTopezCommandErrorNotification
		do: [ :ex | 
			(ex isKindOf: GciError)
				ifTrue: [ 
					| errorMessage |
					"until 50621 is fixed - just return first line of stack"
					self debugMode
						ifTrue: [ ex pass ].
					errorMessage := 'Topez ERROR: ' , ex description readStream nextLine.
					self resetStack.
					^ errorMessage ].
			((ex isKindOf: GsTopezCommandErrorNotification) or: [ ex isKindOf: Error ])
				ifTrue: [ 
					| errorMessage |
					self debugMode
						ifTrue: [ ex pass ].
					errorMessage := 'Topez ERROR: ' , ex description.
					self resetStack.
					^ errorMessage ].

			self logout.	"TDRestoreFromBackupComplete - logout and return restore message"
			^ ex description ]