accessing
todeHome
	todeHome
		ifNil: [ 
			self
				error:
					'The todeHome for this registry has not been set. Please run registerTodeSharedDir.solo to set the todeHome.' ].
	^todeHome