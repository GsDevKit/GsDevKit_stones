export
exportTo: fileRef
	fileRef
		writeStreamDo: [ :fileStream | 
			(Rowan version >= '3.0.0' asRwSemanticVersionNumber
				or: [ self class currentGemStoneVersion >= '3.7.0' asRwGemStoneVersionNumber ])
				ifTrue: [ fileStream truncate ].
			STON put: self onStreamPretty: fileStream ]