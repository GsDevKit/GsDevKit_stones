export
export
	self class configFile
		writeStreamDo: [ :fileStream | 
			Rowan version >= ('3.0.0' asRwGemStoneVersionNumber)
				ifTrue: [ fileStream truncate ].
			STON put: self onStreamPretty: fileStream ].