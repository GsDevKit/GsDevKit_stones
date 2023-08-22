export
exportTo: fileRef
	fileRef
		writeStreamDo: [ :fileStream | 
			fileStream truncate.
			STON put: self onStreamPretty: fileStream ]