stone destruction
destroyStoneStructure: stoneSpec
	| todeDir |
	todeDir := stoneSpec todeSharedDirectory asFileReference / stoneSpec stoneName.
	todeDir ensureDeleteAll