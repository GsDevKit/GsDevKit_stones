stone destruction
destroyStoneStructure: stoneSpec
	"clean up the stone-specific tode meta data"

	| todeHomeDir sessionsFile todeMetaDataDir |
	todeHomeDir := stoneSpec todeHome asFileReference.
	sessionsFile := todeHomeDir / 'sys' / 'local' / 'sessions'
		/ stoneSpec stoneName.
	sessionsFile ensureDelete.
	todeMetaDataDir := todeHomeDir / 'sys' / 'local' / 'server' / 'stones'
		/ stoneSpec stoneName.
	todeMetaDataDir ensureDelete