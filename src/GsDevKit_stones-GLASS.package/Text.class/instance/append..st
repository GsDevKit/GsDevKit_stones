accessing
append: stringOrText 
	self
		replaceFrom: string size + 1
		to: string size + 2
		with: stringOrText