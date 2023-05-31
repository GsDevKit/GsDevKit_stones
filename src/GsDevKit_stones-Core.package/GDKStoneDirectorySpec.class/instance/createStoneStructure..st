stone creation
createStoneStructure: stoneSpec
	| stoneRoot useCustomEnv exportDir gemstoneReference systemConfStream useTranlogDir useExtentDir |
	exportDir := Dictionary new.
	stoneRoot := stoneSpec rootDir.
	useTranlogDir := ''.
	useExtentDir := '/'.
	useCustomEnv := false.
	gemstoneReference := stoneSpec gemstonePath asFileReference.
	System gemEnvironmentVariable: 'GEMSTONE' put: gemstoneReference pathString.
	self class symbolicLink: gemstoneReference linkName: stoneRoot / 'product'.
	(self dbfSource: stoneSpec) copyTo: stoneRoot / 'extent0.dbf'.
	self class chmod: (stoneRoot / 'extent0.dbf') pathString fileMode: 'u+w'.
	gemstoneReference / 'data' / 'system.conf' copyTo: stoneRoot / 'system.conf'.
	systemConfStream := GsFile
		open: (stoneRoot / 'system.conf') pathString
		mode: 'w+'
		onClient: false.	"need to append entries to the file"
	exportDir
		at: GDKGsDevKit_stonesBase dataHomeEnvVar
		put: self class data_home pathString.
	self
		keysAndValuesDo: [ :key :value | 
			key = #'customenv'
				ifTrue: [ 
					useCustomEnv := true.
					customenv := exportDir.
					exportDir
						at: 'stone_dir' put: stoneRoot pathString;
						at: 'GEMSTONE' put: gemstoneReference pathString;
						at: 'PATH'
							put:
								(stoneRoot / 'bin') pathString , ':' , stoneSpec gemstonePath , '/bin:$PATH' ].
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
			key = #'stats'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'tranlogs'
				ifTrue: [ 
					useTranlogDir := '/' , value.
					(stoneRoot / value) ensureCreateDirectory ].
			key = #'snapshots'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = #'projectsHome'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
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
				nextPutAll: 'set u DataCurator p swordfish';
				lf ].
	self class chmod: (stoneRoot / '.topazini') pathString fileMode: 'u+w,og-rw'