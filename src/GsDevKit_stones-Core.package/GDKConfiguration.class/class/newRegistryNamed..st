instance creation
newRegistryNamed: registryName
	| config_home configFile registryFile registry stoneRegistry |
	config_home := self config_home.
	config_home ensureCreateDirectory.
	configFile := config_home / 'configuration.ston'.
	registry := configFile exists
		ifTrue: [ 
			configFile
				readStreamDo: [ :fileStream | 
					| stream |
					stream := ZnBufferedReadStream on: fileStream.	"wrap with buffered stream to bypass https://github.com/GemTalk/FileSystemGs/issues/9"
					STON fromStream: stream ] ]
		ifFalse: [ self new ].
	stoneRegistry := GDKStonesRegistry newNamed: registryName.
	registryFile := stoneRegistry registryFile.
	registryFile exists
		ifTrue: [ 
			self
				error: 'The registry named ' , registryName printString , ' already exists.' ].
	registry at: registryName put: stoneRegistry registryPath.
	configFile
		writeStreamDo: [ :fileStream | STON put: registry onStreamPretty: fileStream ].
	stoneRegistry export.
	^ stoneRegistry