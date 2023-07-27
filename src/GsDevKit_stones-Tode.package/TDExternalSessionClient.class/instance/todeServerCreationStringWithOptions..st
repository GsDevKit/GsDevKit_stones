session management
todeServerCreationStringWithOptions: withOptions
	| str optionsString |
	str := self todeServerAccessString , ' createFor: '
		, self shell shellId asString.
	withOptions
		ifTrue: [ 
			optionsString := true
				ifTrue: [ '' ]
				ifFalse: [ '#transcript' ].
			str := str , ' options: #(' , optionsString , ')' ].
	^ str