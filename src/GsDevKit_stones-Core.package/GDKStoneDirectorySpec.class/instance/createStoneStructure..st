stone creation
createStoneStructure: stoneSpec
	| stoneRoot useCustomEnv exportDict gemstoneReference systemConfStream useTranlogDir useExtentDir userId password |
	exportDict := Dictionary new.
	stoneRoot := stoneSpec rootDir.
	useTranlogDir := ''.
	useExtentDir := '/'.
	useCustomEnv := false.
	userId := self defaultUserId.
	password := 'swordfish'.
	gemstoneReference := stoneSpec gemstonePath asFileReference.
	System gemEnvironmentVariable: 'GEMSTONE' put: gemstoneReference fullName.
	self class symbolicLink: gemstoneReference linkName: stoneRoot / 'product'.
	(self dbfSource: stoneSpec) copyTo: stoneRoot / 'extent0.dbf'.
	self class chmod: (stoneRoot / 'extent0.dbf') fullName fileMode: 'u+w'.
	gemstoneReference / 'data' / 'system.conf' copyTo: stoneRoot / 'system.conf'.
	systemConfStream := GsFile
		open: (stoneRoot / 'system.conf') fullName
		mode: 'a+'
		onClient: false.
	exportDict
		at: GDKGsDevKit_stonesBase dataHomeEnvVar
		put: self class base_data_home fullName.
	self
		keysAndValuesDo: [ :key :value | 
			key = #'customenv'
				ifTrue: [ 
					useCustomEnv := true.
					customenv := exportDict.
					exportDict
						at: 'stone_dir' put: stoneRoot fullName;
						at: 'GEMSTONE' put: gemstoneReference fullName;
						yourself.
					stoneSpec stonesRegistry projectDirectory
						ifNotNil: [ :projectDir | 
							exportDict
								at: 'GDK_stones_projects' put: projectDir asFileReference fullName;
								yourself ].
					self customizeCustomEnv: exportDict stoneSpec: stoneSpec ].
			key = #'bin'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'backups'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'extents'
				ifTrue: [ 
					useExtentDir := '/' , value , '/'.
					(stoneRoot / value) ensureCreateDirectory.
					stoneRoot / 'extent0.dbf' moveTo: stoneRoot / value ].
			key = #'logs'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'netldiPort'
				ifTrue: [ 
					value = 0
						ifTrue: [ 
							| socket status |
							socket := GsSocket new.
							status := socket bindTo: value.
							netldiPort := socket port.
							socket close ] ].
			key = #'stats'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'tode'
				ifTrue: [ self createTodeHomeDirectory: stoneSpec ].
			key = #'tranlogs'
				ifTrue: [ 
					useTranlogDir := '/' , value.
					(stoneRoot / value) ensureCreateDirectory ].
			key = #'snapshots'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'projectsHome'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'userId'
				ifTrue: [ userId := value ].
			key = #'password'
				ifTrue: [ password := value ].
			key = #'product'
				ifTrue: [ 
					"noop, as product symbolic link is created by default"
					 ].
			key = #'gemstone'
				ifTrue: [ 
					"???"
					self halt ] ].
	stoneSpec
		userId: userId;
		password: password;
		yourself.
	self populateStoneBinDirectory: stoneSpec.
	useCustomEnv
		ifTrue: [ 
			self exportCustomEnvTo: stoneRoot / 'customenv'.
			systemConfStream
				lf;
				nextPutAll: 'DBF_EXTENT_NAMES = $stone_dir' , useExtentDir , 'extent0.dbf;';
				lf;
				nextPutAll: 'STN_TRAN_LOG_DIRECTORIES = $stone_dir' , useTranlogDir , ';';
				lf ]
		ifFalse: [ 
			systemConfStream
				lf;
				nextPutAll:
						'DBF_EXTENT_NAMES = ' , stoneRoot fullName , useExtentDir , 'extent0.dbf;';
				lf;
				nextPutAll:
						'STN_TRAN_LOG_DIRECTORIES = ' , stoneRoot fullName , useTranlogDir , ';';
				lf ].
	systemConfStream close.
	stoneRoot / 'gem.conf'
		writeStreamDo: [ :fileStream | 
			Rowan version >= ('3.0.0' asRwSemanticVersionNumber)
				ifTrue: [  fileStream truncate ].
			fileStream
				nextPutAll: 'GEM_TEMPOBJ_CACHE_SIZE = 1000000;';
				lf ].
	stoneRoot / '.topazini'
		writeStreamDo: [ :fileStream | 
			Rowan version >= ('3.0.0' asRwSemanticVersionNumber)
				ifTrue: [fileStream truncate].
			fileStream
				nextPutAll: 'set GEMSTONE ' , stoneSpec stoneName;
				lf;
				nextPutAll: 'set u ' , userId , ' p ' , password;
				lf;
				nextPutAll: 'set singlecolumn on';
				lf  ]