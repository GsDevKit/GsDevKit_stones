accessing
stoneNamed: stoneName
	^ self
		stoneNamed: stoneName
		ifAbsent: [ self error: 'No stone named ' , stoneName , ' found.' ]