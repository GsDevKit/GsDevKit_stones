instance creation
fromFile: filePath
	filePath asFileReference
		readStreamDo: [ :fileStream | 
			| contents |
			contents  := fileStream contents.
			^ STON fromString: contents ]