other
evaluateCommand: command batchMode: batchBool debugMode: debugModeBool
	| stonString |
	stonString := STON toString: command.
	^ self
		_serverExecuteString:
			'(' , self todeServerAccessString , ' for: ' , self shell shellId asString
				, ') evaluateSTONCommand:' , stonString printString
		debugMode: debugModeBool