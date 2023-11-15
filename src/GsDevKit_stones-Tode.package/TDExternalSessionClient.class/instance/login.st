session management
login
	| gemNRS stoneNRS sessionDescription sess lib parameters |
	sessionDescription := self sessionDescription.
	gemNRS := GsNetworkResourceString
		gemNRSForNetLDI: sessionDescription netLDIPort
		onHost: sessionDescription gemHost.
	stoneNRS := GsNetworkResourceString
		stoneNRSForStoneName: sessionDescription stoneName
		onHost: sessionDescription stoneHost.
	(parameters := GemStoneParameters new)
		gemService: gemNRS asString;
		gemStoneName: stoneNRS asString;
		username: sessionDescription userId;
		password: sessionDescription password copy.	"Warning the password size is set to zero during GsTsExternalSession processing -- see GemStoneParameters>>password"
	lib := GciTsLibrary
		newForVersion: sessionDescription gemstoneVersion
		product: sessionDescription gemstoneProductPath.
	sess := GsTsExternalSession parameters: parameters library: lib.
	sess nbLogin.
	sess waitForReadReady.
	sess nbLoginFinished.
	^ sess