stone creation
populateStoneBinDirectory: stoneSpec
	| stoneRoot gs |
	super populateStoneBinDirectory: stoneSpec.
	stoneRoot := stoneSpec rootDir.
	gs := (System gemEnvironmentVariable: 'GEMSTONE') asFileReference.
	#('exportRowanProjectAsTopaz.solo')
		do: [ :scriptName | 
			stoneSpec class
				symbolicLink: gs / 'rowan3' / 'bin' / scriptName
				linkName: stoneSpec rootDir / 'bin' / scriptName ]