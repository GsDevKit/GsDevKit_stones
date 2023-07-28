evaluator engine
evaluate: aString batchMode: aBool
	[ 
	| result |
	TDCommandLine
		fromStream: aString readStream
		selectLine: [ :line | true ]
		forEachCommand: [ :command | result := self evaluateCommand: command batchMode: aBool ].
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