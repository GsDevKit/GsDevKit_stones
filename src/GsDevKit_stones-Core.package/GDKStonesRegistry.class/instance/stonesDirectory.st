accessing
stonesDirectory
	projectDirectory
		ifNil: [ 
			self
				error:
					'The stonesDirectory for this registry has not been set. Please run registerStonesDirectory.solo to set the stonesDirectory.' ].
	^stonesDirectory