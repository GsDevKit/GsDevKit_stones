stone creation
populateStoneBinDirectory: stoneSpec
	| stoneRoot gs |
	stoneRoot := stoneSpec rootDir.
	gs := (System gemEnvironmentVariable: 'GEMSTONE') asFileReference.
	#('attachRowanClone.stone' 'attachRowanDevClones.stone' 'installProject.stone' 'exportRowanProjectAsTopaz.solo')
		do: [ :scriptName | 
			stoneSpec class
				symbolicLink: gs / 'rowan' / 'bin' / scriptName
				linkName: stoneSpec rootDir / 'bin' / scriptName ]