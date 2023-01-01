export
export
	self registryFile
		writeStreamDo: [ :fileStream | STON put: self onStreamPretty: fileStream ]