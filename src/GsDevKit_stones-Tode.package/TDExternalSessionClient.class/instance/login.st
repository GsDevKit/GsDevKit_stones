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
	sessionDescription gemstoneVersion asRwGemStoneVersionNumber
		>= '3.5.8' asRwGemStoneVersionNumber
		ifTrue: [ 
			"3.5.8 is an arbitrary cutoff point ... 3.5.8 works, 3.5.3 does not ... will get finer grained if needed"
			sess := GsTsExternalSession
				gemNRS: gemNRS
				stoneNRS: stoneNRS
				username: sessionDescription userId
				password: sessionDescription password copy.	"Warning the password size is set to zero during GsTsExternalSession processing -- see GemStoneParameters>>password"
			sess nbLogin.
			sess waitForReadReady.
			sess nbLoginFinished ]
		ifFalse: [ 
			| lib parameters |
			(parameters := GemStoneParameters new)
				gemService: gemNRS asString;
				gemStoneName: stoneNRS asString;
				username: sessionDescription userId;
				password: sessionDescription password copy.	"Warning the password size is set to zero during GsTsExternalSession processing -- see GemStoneParameters>>password"
			lib := GciTsLibrary
				newForVersion: sessionDescription gemstoneVersion
				product: sessionDescription gemstoneProductPath.
			sess := GsTsExternalSession parameters: parameters library: lib.
			sess login ].
	^ sess