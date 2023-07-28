printing
printOn: aStream
	| name |
	(name _ self name) ifNotNil:
		[^ aStream
			nextPutAll: 'Color ';
			nextPutAll: name].
	self storeOn: aStream.