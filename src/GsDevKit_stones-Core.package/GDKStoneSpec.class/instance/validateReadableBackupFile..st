backup/restore
validateReadableBackupFile: theBackupPath
	^ self copydbf: '' forFilePath: theBackupPath , ' /dev/null'