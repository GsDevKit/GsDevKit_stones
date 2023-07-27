accessing
allGlobalNames
	AllGlobalNames
		ifNil: [ 
			"may be needed?"
			AllGlobalNames := #() ].
	^ AllGlobalNames