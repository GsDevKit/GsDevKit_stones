session management
login
	| sess gemNRS stoneNRS aUsername aPassword |
	sess := GsTsExternalSession
		gemNRS: gemNRS
		stoneNRS: stoneNRS
		username: aUsername
		password: aPassword.
	(sess loginWith: self sessionDescription)
		ifFalse: [ 
			| gciError messageText |
			gciError := sess getAndClearLastError.
			messageText := gciError message.
			^ Error
				signal:
					messageText
						, ' For further information about login failures, check the gem log file' ].
	self class addDependent: self.
	false
		ifTrue: [ sess enableGemTrace ].
	^ sess