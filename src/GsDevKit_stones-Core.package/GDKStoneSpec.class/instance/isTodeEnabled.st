accessing
isTodeEnabled
	stoneDirectorySpec ifNil: [ ^ false ].
	^ stoneDirectorySpec isTodeEnabled