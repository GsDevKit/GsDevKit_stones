export
export
	self class configFile
		writeStreamDo: [ :fileStream | 
			fileStream truncate.
			STON put: self onStreamPretty: fileStream ].