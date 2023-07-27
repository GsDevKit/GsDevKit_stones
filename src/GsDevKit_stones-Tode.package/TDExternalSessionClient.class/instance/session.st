session management
session
	session
		ifNil: [ 
			session := self login.
			self topezServerProxy ].
	^ session