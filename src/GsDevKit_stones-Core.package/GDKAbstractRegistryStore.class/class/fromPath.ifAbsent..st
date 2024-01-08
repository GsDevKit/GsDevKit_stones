instance creation
fromPath: registryPath ifAbsent: absentBlock
	| registryFile |
	self data_home.	"prime the XDG cache"
	registryFile := registryPath asFileReference.
	registryFile exists
		ifFalse: [ ^ absentBlock value ].
	registryFile
		readStreamDo: [ :fileStream | 
			[ ^ STON fromStream: fileStream ]
				on: STONReaderError
				do: [ :ex | 
					ex
						addText:
							(RwRepositoryResolvedProjectTonelReaderVisitorV2
								lineNumberStringForOffset: fileStream position
								fileName: registryFile fullName).
					ex pass ] ]