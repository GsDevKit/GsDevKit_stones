ston
stonOn: stonWriter
	| theSortedKeys |
	theSortedKeys := self keys sort.
	stonWriter
		writeObject: self
		streamMap: [ :dictionary | theSortedKeys do: [ :each | dictionary at: each asSymbol put: (self at: each) ] ]