objects from disk
bytesPerElement
	^self class isBytes ifTrue: [ 1 ] ifFalse: [ 4 ].