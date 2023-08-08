stone creation
customizeCustomEnv: exportDict stoneSpec: stoneSpec
	"opportunity to add additional env var defs to customenv file"

	{{'GEMSTONE_DATADIR'.
	(stoneSpec todeHome , '/sys/local/server/stones/' , stoneSpec stoneName)}.
	{'GS_SERVER'.
	(stoneSpec todeHome , '/server')}.
	{'GS_SHARED'.
	(stoneSpec todeHome , '/shared')}.
	{'GS_SERVER_STONES'.
	(stoneSpec todeHome , '/sys/local/server/stones')}.
	{'GS_SYS'.
	(stoneSpec todeHome , '/sys')}}
		do: [ :ar | exportDict at: (ar at: 1) put: (ar at: 2) ]