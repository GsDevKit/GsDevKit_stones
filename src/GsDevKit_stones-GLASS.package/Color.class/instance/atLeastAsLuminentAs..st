transformations
atLeastAsLuminentAs: aFloat

	| revisedColor |
	revisedColor _ self.
	[revisedColor luminance < aFloat] whileTrue: [revisedColor _ revisedColor slightlyLighter].
	^revisedColor