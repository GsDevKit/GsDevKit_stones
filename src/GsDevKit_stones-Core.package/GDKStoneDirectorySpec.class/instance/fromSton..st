ston support
fromSton: stonReader
	"Decode non-variable classes from a map of their instance variables and values.
	non-iv mapping achieved with dynamic inst vars."

	| instanceVariableNames |
	instanceVariableNames := self class allInstVarNames.
	stonReader
		parseMapDo: [ :instVarName :value | 
			| ivIndex |
			ivIndex := instanceVariableNames indexOf: instVarName asSymbol.
			ivIndex = 0
				ifTrue: [ self dynamicInstVarAt: instVarName asSymbol put: value ]
				ifFalse: [ self instVarAt: ivIndex put: value ] ]