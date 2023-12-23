ston
stonInstVarNames
	| names |
	names := self class allInstVarNames asOrderedCollection.
	names removeIfPresent: #'gemstoneProductPath'.
	^ names