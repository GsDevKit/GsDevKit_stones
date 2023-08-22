product management
downloadProductNamed: productName
	| downloadDirectoryName productDirPath |
	downloadDirectoryName := self class downloadDirectoryNameFor: productName.
	productDirPath := self productDirectory.
	self
		downloadProductName: productName
		productDirectory: downloadDirectoryName
		to: productDirPath.
	^ (self productDirectory asFileReference / downloadDirectoryName) fullName