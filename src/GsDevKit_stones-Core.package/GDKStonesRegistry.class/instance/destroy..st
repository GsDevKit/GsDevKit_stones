destruction
destroy: force
	| stonesRegistry |
	"stop all running stones and  netldi, destroy stone directories, and remove receiver from the registry metadata" 
	self stones keysDo: [:stoneName | 
		| stoneSpec |
		stoneSpec := self stoneNamed: stoneName.
		force 
			ifTrue: [
			"forcibly shut down stone"
			stoneSpec 
				stopStone: nil
					withSuperDoitOptions: false
					timeout: nil
					immediate: true;
					yourself ]
			ifFalse: [ stoneSpec stopStone ].
		stoneSpec stopNetldi.
		stoneSpec
			destroyStoneStructure;
			yourself.  ].
	self stones keysDo: [:stoneName | 
		self stones removeKey: stoneName ].
	self export.	"will be deleted later"
	('$STONES_DATA_HOME'  asFileReference /  'stone' / self name)   ensureDeleteAll.
	('$STONES_DATA_HOME'  asFileReference /  'projectSets' / self name)   ensureDeleteAll.
	stonesRegistry := GDKRegistry instance.
	stonesRegistry removeKey: self name asSymbol.
	stonesRegistry export.
	self registryFile asFileReference ensureDelete.