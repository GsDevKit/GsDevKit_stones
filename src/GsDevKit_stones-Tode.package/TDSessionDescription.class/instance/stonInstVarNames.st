ston
stonInstVarNames
	| varNames |
	varNames := self class allInstVarNames asOrderedCollection.
	varNames removeIfPresent: #'gemstoneProductPath'.
	^ varNames