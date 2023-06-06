session management
login
	| gemNRS stoneNRS sessionDescription |
	sessionDescription := self sessionDescription.
	gemNRS := GsNetworkResourceString
		gemNRSForNetLDI: sessionDescription netLDIPort
		onHost: sessionDescription gemHost.
	stoneNRS := GsNetworkResourceString
		stoneNRSForStoneName: sessionDescription stoneName
		onHost: sessionDescription stoneHost.
	^ (GsTsExternalSession
		gemNRS: gemNRS
		stoneNRS: stoneNRS
		username: sessionDescription userId
		password: sessionDescription password) login