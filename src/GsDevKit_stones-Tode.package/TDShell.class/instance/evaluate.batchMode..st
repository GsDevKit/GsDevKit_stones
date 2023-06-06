evaluator engine
evaluate: aString batchMode: aBool
	[ 
	| result |
	TDCommandLine
		fromStream: aString readStream
		selectLine: [ :line | 
			self actionStack notEmpty
				ifTrue: [ 
					result := self accumulateText: line.
					false	"do not create or evaluate command for this line" ]
				ifFalse: [ 
					self addToHistory: line.
					true	"create and evaluate the command for this line" ] ]
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