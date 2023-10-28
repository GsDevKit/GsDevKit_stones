backup/restore
checkGcLock: gcLockedBlock

	(System respondsTo: #'sessionsHoldingGcLock')
		ifTrue: [ 
			| sessIds |
			sessIds := System sessionsHoldingGcLock.
			sessIds size > 0
				ifTrue: [ gcLockedBlock value: sessIds ] ]
		ifFalse: [
			| sessId |
			sessId := System sessionIdHoldingGcLock.
			sessId ~~ 0
				ifTrue: [ gcLockedBlock value: sessId ] ]