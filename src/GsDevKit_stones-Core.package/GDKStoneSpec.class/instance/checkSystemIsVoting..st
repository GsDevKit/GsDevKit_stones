backup/restore
checkSystemIsVoting: isVotingBlock
	| vs |
	vs := System voteState.
	(System respondsTo: #'sessionsHoldingGcLock')
		ifTrue: [ 
			| sessIds |
			sessIds := System sessionsHoldingGcLock.
			(sessIds size > 0 or: [ vs > 0 and: [ vs < 4 ] ])
				ifTrue: [ isVotingBlock value: sessIds value: vs ] ]
		ifFalse: [ 
			| sessId |
			sessId := System sessionIdHoldingGcLock.
			(sessId ~~ 0 or: [ vs > 0 and: [ vs < 4 ] ])
				ifTrue: [ isVotingBlock value: sessId value: vs ] ]