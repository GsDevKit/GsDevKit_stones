stone creation
createSessionDescripton: stoneSpec
	| sessionDescriptionFile description localHostName todeHome |
	todeHome := stoneSpec todeHome.
	sessionDescriptionFile := stoneSpec todeHome asFileReference / 'sys' / 'local'
		/ 'sessions' / stoneSpec stoneName.
	localHostName := System hostname.
	description := TDSessionDescription new
		name: stoneSpec stoneName;
		gemstoneVersion: stoneSpec gemstoneVersionString;
		stoneHost: localHostName;
		stoneName: stoneSpec stoneName;
		gemHost: localHostName;
		netLDI: stoneSpec stoneName , '_ldi';
		netLDIPort: self netldiPort asString;
		gemTask: 'gemnetobject';
		userId: stoneSpec userId;
		password: stoneSpec password;
		backupDirectory: (stoneSpec rootDir / self backups) fullName;
		snapshotDirectory: (stoneSpec rootDir / self snapshots) fullName;
		serverGitRoot:
				stoneSpec stonesRegistry projectDirectory asFileReference fullName;
		serverTodeRoot: todeHome asFileReference fullName;
		yourself.
	description exportTo: sessionDescriptionFile