ston
stonOn: stonWriter
	| allInstanceVariableNames |
	allInstanceVariableNames := self class allInstVarNames.
	stonWriter
		writeObject: self
		streamMap: [ :dictionary | 
			self stonInstVarNames
				do: [ :each | 
					dictionary
						at: each asSymbol
						put: (self instVarAt: (allInstanceVariableNames indexOf: each asSymbol)) ] ]