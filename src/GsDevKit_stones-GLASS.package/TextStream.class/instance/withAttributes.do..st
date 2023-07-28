accessing
withAttributes: attributes do: streamBlock 
	| pos1 val |
	pos1 := self position.
	val := streamBlock value.
	attributes do: [:attribute |
		itsCollection
			addAttribute: attribute
			from: pos1
			to: self position].
	^ val