accessing
nextPutAll: aCollection 
	"Optimized access to get around Text at:Put: overhead"
	| n |
	n := aCollection size.
     position + n > itsCollection size
       ifTrue:
        [self growTo: position + n + 10].
	itsCollection 
		replaceFrom: position
		to: position + n - 1
		with: aCollection
		startingAt: 1.
	position := position + n