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
		backupDirectory: (stoneSpec rootDir / self backups) pathString;
		snapshotDirectory: (stoneSpec rootDir / self snapshots) pathString;
		serverGitRoot:
				stoneSpec stonesRegistry projectDirectory asFileReference pathString;
		serverTodeRoot: todeHome asFileReference pathString;
		yourself.
	description exportTo: sessionDescriptionFile