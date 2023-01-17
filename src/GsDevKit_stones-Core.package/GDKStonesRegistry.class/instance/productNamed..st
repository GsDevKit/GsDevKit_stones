product management
productNamed: productName
	"download product if not found"

	^ self
		productNamed: productName
		ifAbsent: [ 
			| productPath |
			productPath := self products at: productName put: (self downloadProductNamed: productName).
			self export.
			productPath ]