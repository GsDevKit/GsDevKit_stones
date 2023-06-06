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