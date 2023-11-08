destruction
destroy: force
	| stonesRegistry |
	"stop all running stones and  netldi, remove receiver from the registry metadata ... the non-registry directory structure including the stone directories are left intact"
	self stones
		keysDo: [ :stoneName | 
			| stoneSpec |
			stoneSpec := self stoneNamed: stoneName.
			force
				ifTrue: [ 
					"forcibly shut down stone and netldi"
					stoneSpec
						stopStone: nil
							withSuperDoitOptions: false
							timeout: nil
							immediate: true;
						yourself.
					stoneSpec stopNetldi ].
			(stoneSpec rootDir / '.GDKStoneSpec.ston') ensureDelete	"remove the .GDKStoneSpec.ston symbolic link, since we're destroying the referenced file" ].
	self stones keysDo: [ :stoneName | self stones removeKey: stoneName ].
	self export.	"will be deleted later"
	('$STONES_DATA_HOME' asFileReference / 'stone' / self name) ensureDeleteAll.
	('$STONES_DATA_HOME' asFileReference / 'projectSets' / self name)
		ensureDeleteAll.
	stonesRegistry := GDKRegistry instance.
	stonesRegistry removeKey: self name asSymbol.
	stonesRegistry export.
	self registryFile asFileReference ensureDelete