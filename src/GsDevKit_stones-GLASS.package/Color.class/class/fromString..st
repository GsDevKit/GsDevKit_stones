instance creation
fromString: aString
	"for HTML color spec: #FFCCAA or white/black"
	"Color fromString: '#FFCCAA'.
	 Color fromString: 'white'.
	 Color fromString: 'orange'"
	| aColorHex red green blue |
	aString isEmptyOrNil ifTrue: [^ Color white].
	aString first = $#
		ifTrue: [aColorHex _ aString copyFrom: 2 to: aString size]
		ifFalse: [aColorHex _ aString].
	[aColorHex size = 6
		ifTrue:
			[aColorHex _ aColorHex asUppercase.
			red _ ('16r', (aColorHex copyFrom: 1 to: 2)) asNumber/255.
			green _ ('16r', (aColorHex copyFrom: 3 to: 4)) asNumber/255.
			blue _ ('16r', (aColorHex copyFrom: 5 to: 6)) asNumber/255.
			^ self r: red g: green b: blue]]
	ifError: [:err :rcvr | "not a hex color triplet" ].
	
	"try to match aColorHex with known named colors"
	aColorHex _ aColorHex asLowercase.

	^self perform: (ColorNames detect: [:i | i asString asLowercase = aColorHex]
		ifNone: [#white])