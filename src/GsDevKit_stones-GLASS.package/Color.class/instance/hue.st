access
hue
	"Return the hue of this color, an angle in the range [0.0..360.0]."

	| r g b max min span h |
	r _ self privateRed.
	g _ self privateGreen.
	b _ self privateBlue. 

	max _ ((r max: g) max: b).
	min _ ((r min: g) min: b).
	span _ (max - min) asFloat.
	span = 0.0 ifTrue: [ ^ 0.0 ].

	r = max ifTrue: [
		h _ ((g - b) asFloat / span) * 60.0.
	] ifFalse: [
		g = max
			ifTrue: [ h _ 120.0 + (((b - r) asFloat / span) * 60.0). ]
			ifFalse: [ h _ 240.0 + (((r - g) asFloat / span) * 60.0). ].
	].

	h < 0.0 ifTrue: [ h _ 360.0 + h ].
	^ h