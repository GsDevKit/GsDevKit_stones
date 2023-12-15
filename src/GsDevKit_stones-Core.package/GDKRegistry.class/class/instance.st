accessing
instance
	| configFile |
	configFile := self configFile.
	^ configFile exists
		ifTrue: [ 
			configFile
				readStreamDo: [ :fileStream | 
					[ STON fromStream: fileStream ]
						on: STONReaderError
						do: [ :ex | 
							ex
								addText:
									(RwRepositoryResolvedProjectTonelReaderVisitorV2
										lineNumberStringForOffset: fileStream position
										fileName: configFile fullName).
							ex pass ] ] ]
		ifFalse: [ self new ]