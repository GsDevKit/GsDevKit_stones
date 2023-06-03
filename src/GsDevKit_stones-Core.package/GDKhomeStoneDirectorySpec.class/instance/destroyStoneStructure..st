stone destruction
destroyStoneStructure: stoneSpec
	"clean up the stone-specific tode meta data"

	| sharedtodeDir stoneDir sessionsFile |
self halt.
	sharedtodeDir := stoneSpec todeSharedDirectory asFileReference.
	stoneDir := sharedtodeDir / 'stones' / stoneSpec stoneName.
	stoneDir ensureDeleteAll.
	sessionsFile := sharedtodeDir / 'sessions' / stoneSpec stoneName.
	sessionsFile ensureDelete