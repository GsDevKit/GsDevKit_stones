accessing
projectSetNamed: projectSetName
	^ self
		projectSetNamed: projectSetName
		ifAbsent: [ self error: 'No project set named ' , projectSetName , ' found.' ]