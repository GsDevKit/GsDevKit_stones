as yet unclassified
defaultAction
	| result |
	result := self performSendNoForwarder: [ self resume: (Array with: #resume with: nil) ].
	^(Array with: #resume with: result)