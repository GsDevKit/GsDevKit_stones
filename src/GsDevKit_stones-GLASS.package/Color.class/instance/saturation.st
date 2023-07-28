access
saturation
	"Return the saturation of this color, a value between 0.0 and 1.0."

	| r g b max min |
	r _ self privateRed.
	g _ self privateGreen.
	b _ self privateBlue. 

	max _ min _ r.
	g > max ifTrue: [max _ g].
	b > max ifTrue: [max _ b].
	g < min ifTrue: [min _ g].
	b < min ifTrue: [min _ b].

	max = 0
		ifTrue: [ ^ 0.0 ]
		ifFalse: [ ^ (max - min) asFloat / max asFloat ].