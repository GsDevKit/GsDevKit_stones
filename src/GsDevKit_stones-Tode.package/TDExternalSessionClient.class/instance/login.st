session management
login
	| gemNRS stoneNRS sessionDescription sess |
	sessionDescription := self sessionDescription.
	gemNRS := GsNetworkResourceString
		gemNRSForNetLDI: sessionDescription netLDIPort
		onHost: sessionDescription gemHost.
	stoneNRS := GsNetworkResourceString
		stoneNRSForStoneName: sessionDescription stoneName
		onHost: sessionDescription stoneHost.
	sess := GsTsExternalSession
		gemNRS: gemNRS
		stoneNRS: stoneNRS
		username: sessionDescription userId
		password: sessionDescription password.
	sess nbLogin.
	sess waitForReadReady.
	sess nbLoginFinished.
	^ sess