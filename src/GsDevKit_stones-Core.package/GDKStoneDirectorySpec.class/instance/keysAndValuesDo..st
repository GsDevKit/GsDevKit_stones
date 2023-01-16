ston support
keysAndValuesDo: aBlock
	"called from encodeMap:"

	| instanceVariableNames dynamicPairs |
	instanceVariableNames := self class allInstVarNames.
	instanceVariableNames
		do: [ :instVarName | 
			| ivIndex |
			ivIndex := instanceVariableNames indexOf: instVarName asSymbol.
			(self instVarAt: ivIndex)
				ifNotNil: [ :value | aBlock value: instVarName asSymbol value: value ] ].
	dynamicPairs := self dynamicInstVarPairs.
	1 to: dynamicPairs size by: 2 do: [ :index | 
		(dynamicPairs at: index + 1)
			ifNotNil: [ :value | aBlock value: (dynamicPairs at: index) asSymbol value: value ] ]