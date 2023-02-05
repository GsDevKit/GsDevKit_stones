accessing
instance
	| configFile |
	configFile := self configFile.
	^ configFile exists
		ifTrue: [ 
			configFile
				readStreamDo: [ :fileStream | 
					| stream |
					stream := ZnBufferedReadStream on: fileStream.	"wrap with buffered stream to bypass https://github.com/GemTalk/FileSystemGs/issues/9"
					STON fromStream: stream ] ]
		ifFalse: [ self new ]