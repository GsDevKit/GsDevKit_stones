product management
productNamed: productName ifAbsent: absentBlock
	"safe to use when testing whether or not product has been downloaded"

	^ self products at: productName ifAbsent: absentBlock