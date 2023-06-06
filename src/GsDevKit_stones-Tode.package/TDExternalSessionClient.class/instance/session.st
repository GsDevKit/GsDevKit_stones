session management
session
	session ifNil: [ session := self login ].
	^ session