backup/restore
fullBackupTo: backupPath safely: safely compressed: compressed
	| backupFile result transactionMode |
	transactionMode := System transactionMode.
	backupFile := backupPath asFileReference.
	backupFile exists
		ifTrue: [ 
			safely
				ifTrue: [ 
					GsFile stdout
						nextPutAll:
								'Skipping backup, --safely specified and ' , backupFile fullName , ' exists.';
						lf.
					^ false ].
			backupFile delete ].
	result := compressed
		ifTrue: [ SystemRepository fullBackupGzCompressedTo: backupPath ]
		ifFalse: [ SystemRepository fullBackupTo: backupPath ].
	result == true
		ifFalse: [ ^ self error: 'Could not complete the backup: ' , result ].
	System transactionMode: transactionMode.	"we have been left outside of transaction in manual transaction mode"
	^ true