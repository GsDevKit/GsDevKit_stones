product management
downloadDirectoryNameFor: productName
	| gemVersionReport |
	gemVersionReport := System gemVersionReport.
	^ 'GemStone64Bit' , productName , '-' , (gemVersionReport at: 'cpuKind')
		, '.' , (gemVersionReport at: 'osName')