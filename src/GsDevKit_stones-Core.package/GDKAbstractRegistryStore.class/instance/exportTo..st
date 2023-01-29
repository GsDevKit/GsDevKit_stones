export
exportTo: fileRef
	fileRef
		writeStreamDo: [ :fileStream | STON put: self onStreamPretty: fileStream ]