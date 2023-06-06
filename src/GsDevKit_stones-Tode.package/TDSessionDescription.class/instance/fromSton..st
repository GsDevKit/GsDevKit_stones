ston
fromSton: stonReader
	| allInstanceVariableNames |
	allInstanceVariableNames := self stonInstVarNames.
	stonReader
		parseMapDo: [ :instVarName :value | 
			[ 
			self
				instVarAt: (allInstanceVariableNames indexOf: instVarName asSymbol)
				put: value ]
				on: Error
				do: [ :ignored | 
					"If the instance variable for a TDsessionDescription is missing ... it is for a good reason ... keep on truckin' ... if it's critical let's find out during execution rather than during import"
					 ] ]