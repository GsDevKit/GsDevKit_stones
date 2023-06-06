session management
login
	| sess gemNRS stoneNRS sessionDescription |
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
		password: sessionDescription password