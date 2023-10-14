accessing
isRowanEnabled
	stoneDirectorySpec ifNil: [ ^ false ].
	^ stoneDirectorySpec isRowanEnabled