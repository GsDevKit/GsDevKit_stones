accessing
registryNamed: registryName ifAbsent: absentBlock
	| config_home configFile configuration |
	config_home := self config_home.
	configFile := config_home / 'configuration.ston'.
	configuration := configFile exists
		ifTrue: [ 
			configFile
				readStreamDo: [ :fileStream | 
					| stream |
					stream := ZnBufferedReadStream on: fileStream.	"wrap with buffered stream to bypass https://github.com/GemTalk/FileSystemGs/issues/9"
					STON fromStream: stream ] ]
		ifFalse: [ ^ absentBlock value ].
	^ GDKStonesRegistry
		fromPath: (configuration at: registryName asSymbol ifAbsent: absentBlock)
		ifAbsent: absentBlock