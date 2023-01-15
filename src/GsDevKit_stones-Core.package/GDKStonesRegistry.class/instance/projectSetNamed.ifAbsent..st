accessing
projectSetNamed: projectSetName ifAbsent: absentBlock
	^ self projectSets at: projectSetName ifAbsent: absentBlock