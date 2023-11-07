export
export
	self class configFile
		writeStreamDo: [ :fileStream | 
			(Rowan version >= '3.0.0' asRwSemanticVersionNumber
				or: [ self class currentGemStoneVersion asRwGemStoneVersionNumber >= '3.7.0' ])
				ifTrue: [ fileStream truncate ].
			STON put: self onStreamPretty: fileStream ]