as yet unspecified
newNamed: registryName
  | config_home configFile registryFile registry stoneRegistry |
  config_home := self config_home / 'config'.
	config_home ensureCreateDirectory.
  configFile := config_home / 'registry.ston'.
  registry := configFile exists
    ifTrue: [ configFile readStreamDo: [ :fileStream | STON fromStream: fileStream ] ]
    ifFalse: [ self new ].
  stoneRegistry := GDKStonesRegistry newNamed: registryName.
  registryFile := stoneRegistry registryFile.
  registryFile exists
    ifTrue: [ 
      self
        error:
          'The registry named ' , registryName printString , ' already exists.' ].
  registry at: registryName put: registryFile pathString.
  configFile
    writeStreamDo: [ :fileStream | STON put: registry onStreamPretty: fileStream ].
  stoneRegistry registryFile
    writeStreamDo: [ :fileStream | STON put: stoneRegistry onStreamPretty: fileStream ]
