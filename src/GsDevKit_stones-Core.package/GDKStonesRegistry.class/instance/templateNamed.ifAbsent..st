accessing
templateNamed: templateName ifAbsent: absentBlock
	^ self templates at: templateName ifAbsent: absentBlock