evaluation
evaluateCommand: command batchMode: batchBool
	| stonString |
	stonString := (STON toString: command) encodeAsUTF8.
	^ self session
		executeStringExpectingStringNB:
			'(' , self todeServerAccessString , ' for: ' , self shell shellId asString , ') evaluateSTONCommand:'
				, stonString printString
		envId: self environmentId