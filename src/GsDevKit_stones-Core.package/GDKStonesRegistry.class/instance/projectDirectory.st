accessing
projectDirectory
	projectDirectory
		ifNil: [ 
			self
				error:
					'The projectDirectory for this registry has not been set. Please run registerProjectDirectory.solo to set the projectDirectory.' ].
	^projectDirectory