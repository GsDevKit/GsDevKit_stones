stone creation
createSessionDescripton: stoneSpec
	| sessionDescriptionFile |
	sessionDescriptionFile := stoneSpec todeSharedDirectory asFileReference / 'sessions'
		/ stoneSpec stoneName.
	sessionDescriptionFile ensureCreateFile