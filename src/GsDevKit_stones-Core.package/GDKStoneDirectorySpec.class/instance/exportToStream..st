as yet unspecified
exportToStream: fileStream
	STON put: self copy initializeForExport onStreamPretty: fileStream
