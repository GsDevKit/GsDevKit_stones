stone creation
createStoneStructure: stoneSpec
	| stoneRoot useCustomEnv exportDir gemstoneReference systemConfStream useTranlogDir useExtentDir userId password |
	exportDir := Dictionary new.
	stoneRoot := stoneSpec rootDir.
	useTranlogDir := ''.
	useExtentDir := '/'.
	useCustomEnv := false.
	userId := 'DataCurator'.
	password := 'swordfish'.
	gemstoneReference := stoneSpec gemstonePath asFileReference.
	System gemEnvironmentVariable: 'GEMSTONE' put: gemstoneReference pathString.
	self class symbolicLink: gemstoneReference linkName: stoneRoot / 'product'.
	(self dbfSource: stoneSpec) copyTo: stoneRoot / 'extent0.dbf'.
	self class chmod: (stoneRoot / 'extent0.dbf') pathString fileMode: 'u+w'.
	gemstoneReference / 'data' / 'system.conf' copyTo: stoneRoot / 'system.conf'.
	systemConfStream := GsFile
		open: (stoneRoot / 'system.conf') pathString
		mode: 'a+'
		onClient: false.
	exportDir
		at: GDKGsDevKit_stonesBase dataHomeEnvVar
		put: self class base_data_home pathString.
	self
		keysAndValuesDo: [ :key :value | 
			key = #'customenv'
				ifTrue: [ 
					useCustomEnv := true.
					customenv := exportDir.
					exportDir
						at: 'stone_dir' put: stoneRoot pathString;
						at: 'GEMSTONE' put: gemstoneReference pathString;
						at: 'GDK_stones_projects'
							put: stoneSpec stonesRegistry projectDirectory asFileReference pathString;
						yourself ].
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
				ifTrue: [ self createTodeSharedDirectory: stoneSpec ].
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
	useCustomEnv
		ifTrue: [ 
			stoneRoot / 'customenv'
				writeStreamDo: [ :fileStream | 
					exportDir
						keysAndValuesDo: [ :key :value | 
							fileStream
								nextPutAll: 'export ' , key , '=' , value;
								lf ] ].
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
						'DBF_EXTENT_NAMES = ' , stoneRoot pathString , useExtentDir , 'extent0.dbf;';
				lf;
				nextPutAll:
						'STN_TRAN_LOG_DIRECTORIES = ' , stoneRoot pathString , useTranlogDir , ';';
				lf ].
	systemConfStream close.
	stoneRoot / 'gem.conf'
		writeStreamDo: [ :fileStream | 
			fileStream
				nextPutAll: 'GEM_TEMPOBJ_CACHE_SIZE = 1000000;';
				lf ].
	stoneRoot / '.topazini'
		writeStreamDo: [ :fileStream | 
			fileStream
				nextPutAll: 'set GEMSTONE ' , stoneSpec stoneName;
				lf;
				nextPutAll: 'set u ' , userId , ' p ' , password;
				lf ].
	self class chmod: (stoneRoot / '.topazini') pathString fileMode: 'u+w,og-rw'