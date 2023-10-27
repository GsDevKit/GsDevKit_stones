backup/restore
backupStone: backupPath waitForVotingToComplete: waitForVotingToComplete systemIsVotingBlock: systemIsVoting2ArgBlock safely: safely compressed: compressed validate: validate
	| theBackupPath |
	waitForVotingToComplete
		ifTrue: [ 
			GsFile stdout
				nextPutAll: 'Waiting for vote to complete...';
				lf.
			System waitForVoteStateIdle.
			self
				checkGcLock: [ :sessionHoldingGcLock | 
					self
						error:
							'System has completed voting, but the gc lock is still being held by session with id '
								, sessionHoldingGcLock printString , '.' ].
			GsFile stdout
				nextPutAll: 'Vote complete.';
				lf ]
		ifFalse: [ self checkSystemIsVoting: systemIsVoting2ArgBlock ].
	theBackupPath := compressed
		ifTrue: [ 
			| postFix |
			postFix := '.gz'.
			(backupPath endsWith: postFix)
				ifTrue: [ backupPath ]
				ifFalse: [ backupPath , postFix ] ]
		ifFalse: [ backupPath ].
	GsFile stdout
		nextPutAll:
				'---Starting backup to ' , theBackupPath printString , ' ('
						, DateAndTime now asString , ')';
		lf.
	(self fullBackupTo: theBackupPath safely: safely compressed: compressed)
		ifFalse: [ ^ false ].
	validate
		ifTrue: [ 
			GsFile stdout
				nextPutAll: '---validating backup (' , DateAndTime now asString , ')';
				lf.
			self validateReadableBackupFile: theBackupPath ].
	GsFile stdout
		nextPutAll: '---Finished backup to ' , theBackupPath;
		lf.
	^ true