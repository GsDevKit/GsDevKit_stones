instance creation
fromPath: registryPath ifAbsent: absentBlock
	| registryFile |
	self data_home. "prime the XDG cache"
	registryFile := registryPath asFileReference.
	registryFile exists
		ifFalse: [ ^ absentBlock value ].
	registryFile
		readStreamDo: [ :fileStream | 
			| stream |
			stream := ZnBufferedReadStream on: fileStream.	"wrap with buffered stream to bypass https://github.com/GemTalk/FileSystemGs/issues/9"
			^ STON fromStream: stream ]