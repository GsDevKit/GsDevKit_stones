product management
downloadProductNamed: productName
	| gemVersionReport downloadFileName productDirPath |
	gemVersionReport := System gemVersionReport.
	downloadFileName := 'GemStone64Bit' , productName , '-'
		, (gemVersionReport at: 'cpuKind') , '.' , (gemVersionReport at: 'osName').
	productDirPath := self productDirectory.
	self
		downloadProductName: productName
		productFile: downloadFileName
		to: productDirPath.
	^(self productDirectory asFileReference / downloadFileName) pathString