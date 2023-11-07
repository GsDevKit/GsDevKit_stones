scripts
copyExtent: extentRef toStoneSpec: stoneSpec  script: scriptOrNil withSuperDoitOptions: withSuperDoitOptions
	|  stoneDirectorySpec status extentsDir tranlogsDir stdout targetExtent basename stoneName  |
	stoneName := stoneSpec name.
	basename := scriptOrNil
		ifNil: [ '' ]
		ifNotNil: [ :script | '(' , script basename , ')' ].
	(stoneSpec waitStone: -1) = 0
		ifTrue: [ 
			"if running"
			stoneSpec
				stopStone: nil immediate: true;
				yourself ].
	(status := stoneSpec waitStone: -1) ~= 3
		ifTrue: [ 
			self
				error:
					'Error stone ' , stoneName printString , ' did not shutdown properly (status = '
						, status printString , ') (' , basename , ')' ].
	stoneDirectorySpec := stoneSpec stoneDirectorySpec.
	extentsDir := tranlogsDir := stoneSpec root asFileReference.
	stoneDirectorySpec tranlogs
		ifNotNil: [ :tranDirName | tranlogsDir := tranlogsDir / tranDirName ].
	(tranlogsDir children
		select: [ :child | child extension = 'dbf' and: [ child basename beginsWith: 'tranlog' ] ])
		do: [ :tranlog | tranlog delete ].
	stoneDirectorySpec extents
		ifNotNil: [ :extentsDirName | extentsDir := extentsDir / extentsDirName ].
	targetExtent := extentsDir / 'extent0.dbf'.
	targetExtent ensureDelete.
	extentRef copyTo: targetExtent.
	stdout := scriptOrNil
		ifNil: [ GsFile stdout ]
		ifNotNil: [ :script | script stdout ].
	stdout
		lf;
		nextPutAll:
				extentRef fullName , '======	copied at ' , DateAndTime now printString;
		lf.
	stoneDirectorySpec class chmod: targetExtent fullName fileMode: 'u+w'.
	stoneSpec startStone: scriptOrNil withSuperDoitOptions: withSuperDoitOptions