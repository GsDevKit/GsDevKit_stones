session management
session
	session
		ifNil: [ 
			session := self login.
			self topezServerProxy.
			self _setupSessionForGsDevKit_stones].
	^ session