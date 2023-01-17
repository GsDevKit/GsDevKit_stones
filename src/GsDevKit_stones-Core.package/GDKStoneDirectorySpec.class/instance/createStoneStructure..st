stone creation
createStoneStructure: stoneSpec
	| stoneRoot useCustomEnv exportDir gemstoneReference systemConfStream useTranlogDir useExtentDir |
	exportDir := Dictionary new.
	stoneRoot := stoneSpec rootDir.
	useTranlogDir := ''.
	useExtentDir := ''.
	useCustomEnv := false.
	gemstoneReference := stoneSpec gemstonePath asFileReference.
	gemstoneReference / 'bin' / 'extent0.dbf' copyTo: stoneRoot / 'extent0.dbf'.	"need to append entries to the file"
	gemstoneReference / 'data' / 'system.conf' copyTo: stoneRoot / 'system.conf'.	"need to append entries to the file"
	systemConfStream := GsFile
		open: (stoneRoot / 'system.conf') pathString
		mode: 'w+'
		onClient: false.
	self
		keysAndValuesDo: [ :key :value | 
			key = 'customenv'
				ifTrue: [ 
					useCustomEnv := true.
					exportDir
						at: 'stone_dir' put: stoneRoot pathString;
						at: 'GEMSTONE' put: gemstoneReference pathString;
						at: 'PATH'
							put:
								(stoneRoot pathString / 'bin') pathString , ':' , stoneSpec gemstonePath
										, '/bin:$PATH' ].
			key = 'bin'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = 'backups'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = 'extents'
				ifTrue: [ 
					useExtentDir := '/' , value.
					(stoneRoot / value) ensureCreateDirectory ].
			key = 'logs'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = 'stats'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = 'tranlogs'
				ifTrue: [ 
					useTranlogDir := '/' , value.
					(stoneRoot / value) ensureCreateDirectory ].
			key = 'snapshots'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = 'projectsHome'
				ifTrue: [ (stoneRoot / value) ensureCreateDirectory ].
			key = 'product'
				ifTrue: [ 
					"???"
					self halt ].
			key = 'gemstone'
				ifTrue: [ 
					"???"
					self halt ] ].
	useCustomEnv
		ifTrue: [ 
			(stoneRoot / 'customenv') writeStream
				do: [ :fileStream | 
					exportDir
						keysAndValuesDo:
								[ :key :value | 
									fileStream
										nextPutAll: 'export ' , key , '=' , value;
										lf ] fileStream
							nextPutAll: 'export stone_dir=' , stoneRoot pathString;
						lf;
						nextPutAll: 'export GEMSTONE=' , stoneSpec gemstonePath;
						lf;
						nextPutAll: 'export PATH=$stone_dir/bin:$GEMSTONE/bin:$PATH';
						lf;
						nextPutAll: 'export SANDBOX=$stone_dir/sandbox';
						lf ].
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
						'DBF_EXTENT_NAMES = ' , stoneRoot pathString , useExtentDir , '/extent0.dbf;';
				lf;
				nextPutAll:
						'STN_TRAN_LOG_DIRECTORIES = ' , stoneRoot pathString , useTranlogDir , ';';
				lf ].
	systemConfStream close.
	stoneRoot / 'gem.conf'
		writeStreamDo: [ :fileStream | 
			fileStream
				nextPutAll: 'GEM_TEMPOBJ_CACHE_SIZE = 1000000;';
				lf ]