export
exportTo: fileRef
	fileRef
		writeStreamDo: [ :fileStream | 
			Rowan version >= ('3.0.0' asRwSemanticVersionNumber)
				ifTrue: [ fileStream truncate ].
			STON put: self onStreamPretty: fileStream ]