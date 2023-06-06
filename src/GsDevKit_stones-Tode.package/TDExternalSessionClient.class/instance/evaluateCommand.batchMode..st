evaluation
evaluateCommand: command batchMode: batchBool
	| stonString |
	stonString := STON toString: command.
	^ self session
		executeString:
			'(' , self todeServerAccessString , ' for: ' , self shell shellId asString
				, ') evaluateSTONCommand:' , stonString printString