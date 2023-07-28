transformations
atMostAsLuminentAs: aFloat

	| revisedColor |
	revisedColor _ self.
	[revisedColor luminance > aFloat] whileTrue: [revisedColor _ revisedColor slightlyDarker].
	^revisedColor