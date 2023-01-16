accessing
templateNamed: templateName
	^ self
		templateNamed: templateName
		ifAbsent: [ self error: 'No template named ' , templateName , ' found.' ]