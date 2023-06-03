stone destruction
destroyStoneStructure: stoneSpec
	"clean up the stone-specific tode meta data"

	| sharedtodeDir stoneDir sessionsFile |
	sharedtodeDir := stoneSpec todeSharedDirectory asFileReference.
	stoneDir := sharedtodeDir / 'server' / 'stones' / stoneSpec stoneName.
	stoneDir ensureDeleteAll.
	sessionsFile := sharedtodeDir / 'sessions' / stoneSpec stoneName.
	sessionsFile ensureDelete