
SET PACKAGE: GsDevKit_stones-Core
! Class Declarations
doit
(Object
	subclass: 'GDKStoneDirectorySpec'
	instVarNames: #( root backups bin extents logs stats tranlogs snapshots projectsHome product gemstone )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.
%

removeallmethods GDKStoneDirectorySpec
removeallclassmethods GDKStoneDirectorySpec

doit
(GDKStoneDirectorySpec
	subclass: 'GDK_homeStoneDirectorySpec'
	instVarNames: #(  )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.
%

removeallmethods GDK_homeStoneDirectorySpec
removeallclassmethods GDK_homeStoneDirectorySpec

doit
(Object
	subclass: 'GDKStoneRegistry'
	instVarNames: #( stoneName stoneDirectorySpec )
	classVars: #(  )
	classInstVars: #(  )
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.
%

removeallmethods GDKStoneRegistry
removeallclassmethods GDKStoneRegistry

! Class implementation for 'GDKStoneDirectorySpec'

!		Class methods for 'GDKStoneDirectorySpec'

category: 'instance creation'
classmethod: GDKStoneDirectorySpec
new
	^ super new initialize
%

category: 'instance creation'
classmethod: GDKStoneDirectorySpec
root: aFileReferenceOrPath
	"if aFileReferenceOrPath exists, it will be deleted and recreated ... empty"

	^ self new
		root: aFileReferenceOrPath asFileReference;
		yourself
%

category: 'instance creation'
classmethod: GDKStoneDirectorySpec
root: aFileReferenceOrPath projectsHome: aProjectsHome gemstone: gemstonePath
	"if aFileReferenceOrPath exists, it will be deleted and recreated ... empty"

	^ self new
		root: aFileReferenceOrPath asFileReference
			projectsHome: aProjectsHome
			gemstone: gemstonePath;
		yourself
%

category: 'dev'
classmethod: GDKStoneDirectorySpec
_createdefaultSpec
	"self _createdefaultSpec"

	((Rowan projectNamed: 'GsDevKit_stones') repositoryRoot / 'templates'
		/ 'defaultDirectorySpec.ston') asFileReference
		writeStreamDo: [ :stream | stream nextPutAll: (STON toStringPretty: GDKStoneDirectorySpec new) ]
%

!		Instance methods for 'GDKStoneDirectorySpec'

category: 'accessing'
method: GDKStoneDirectorySpec
backups
	^backups
%

category: 'accessing'
method: GDKStoneDirectorySpec
backups: object
	backups := object
%

category: 'directories'
method: GDKStoneDirectorySpec
backupsDir
	| dir |
	dir := self root / backups.
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
bin
	^bin
%

category: 'accessing'
method: GDKStoneDirectorySpec
bin: object
	bin := object
%

category: 'directories'
method: GDKStoneDirectorySpec
binDir
	| dir |
	dir := self root / self bin.
	dir ensureCreateDirectory.
	^ dir
%

category: 'exporting'
method: GDKStoneDirectorySpec
exportToStream: fileStream
	STON put: self copy initializeForExport onStreamPretty: fileStream
%

category: 'accessing'
method: GDKStoneDirectorySpec
extents
	^extents
%

category: 'accessing'
method: GDKStoneDirectorySpec
extents: object
	extents := object
%

category: 'directories'
method: GDKStoneDirectorySpec
extentsDir
	| dir |
	dir := self root / self extents.
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
gemstone
	^gemstone
%

category: 'accessing'
method: GDKStoneDirectorySpec
gemstone: object
	gemstone := object
%

category: 'initialization'
method: GDKStoneDirectorySpec
initialize
	super initialize.
	backups := 'backups'.
	bin := 'bin'.
	extents := 'extents'.
	logs := 'logs'.
	product := 'product'.
	snapshots := 'snapshots'.
	stats := 'stats'.
	tranlogs := 'tranlogs'
%

category: 'initialization'
method: GDKStoneDirectorySpec
initializeForExport
	root ifNotNil: [ root := root pathString ]
%

category: 'initialization'
method: GDKStoneDirectorySpec
initializeForImport
	root ifNotNil: [ root := root asFileReference ]
%

category: 'accessing'
method: GDKStoneDirectorySpec
logs
	^logs
%

category: 'accessing'
method: GDKStoneDirectorySpec
logs: object
	logs := object
%

category: 'directories'
method: GDKStoneDirectorySpec
logsDir
	| dir |
	dir := self root / self logs.
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
product
	^product
%

category: 'accessing'
method: GDKStoneDirectorySpec
product: object
	product := object
%

category: 'directories'
method: GDKStoneDirectorySpec
productDir
	| dir res |
	dir := self root / self product.
	dir exists
		ifFalse: [ 
			res := System
				performOnServer:
					'ln -s ' , self gemstone asFileReference pathString , ' ' , dir pathString ].
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
projectsHome
	^projectsHome
%

category: 'accessing'
method: GDKStoneDirectorySpec
projectsHome: object
	projectsHome := object
%

category: 'directories'
method: GDKStoneDirectorySpec
projectsHomeDir
	^ self root / self projectsHome
%

category: 'accessing'
method: GDKStoneDirectorySpec
root
	^ root
%

category: 'initialization'
method: GDKStoneDirectorySpec
root: aFileReference projectsHome: aProjectsHome gemstone: gemstonePath
	root := aFileReference asFileReference.
	root ensureDeleteAll.
	aFileReference ensureCreateDirectory.
	self projectsHome: aProjectsHome.
	self gemstone: gemstonePath.
	self class instVarNames
		do: [ :iv | 
			(#(#'root' #'projectHome' #'gemstone') includes: iv)
				ifFalse: [ self perform: (iv , 'Dir') asSymbol ] ].
	aFileReference / 'directorySpec.ston'
		writeStreamDo: [ :stream | self exportToStream: stream ]
%

category: 'accessing'
method: GDKStoneDirectorySpec
snapshots
	^snapshots
%

category: 'accessing'
method: GDKStoneDirectorySpec
snapshots: object
	snapshots := object
%

category: 'directories'
method: GDKStoneDirectorySpec
snapshotsDir
	| dir |
	dir := self root / self snapshots.
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
stats
	^stats
%

category: 'accessing'
method: GDKStoneDirectorySpec
stats: object
	stats := object
%

category: 'directories'
method: GDKStoneDirectorySpec
statsDir
	| dir |
	dir := self root / self stats.
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
tranlogs
	^tranlogs
%

category: 'accessing'
method: GDKStoneDirectorySpec
tranlogs: object
	tranlogs := object
%

category: 'directories'
method: GDKStoneDirectorySpec
tranlogsDir
	| dir |
	dir := self root / self tranlogs.
	dir ensureCreateDirectory.
	^ dir
%

! Class implementation for 'GDK_homeStoneDirectorySpec'

!		Class methods for 'GDK_homeStoneDirectorySpec'

category: 'instance creation'
classmethod: GDK_homeStoneDirectorySpec
root: aFileReferenceOrPath gemstone: gemstonePath
	"if aFileReferenceOrPath exists, it will be deleted and recreated ... empty"

	^ self new
		root: aFileReferenceOrPath asFileReference
		gemstone: gemstonePath;
		yourself
%

!		Instance methods for 'GDK_homeStoneDirectorySpec'

category: 'initialization'
method: GDK_homeStoneDirectorySpec
root: aFileReference gemstone: gemstonePath
	self
		root: aFileReference
		projectsHome: self _defaultProjectsHome
		gemstone: gemstonePath
%

category: 'private'
method: GDK_homeStoneDirectorySpec
_defaultProjectsHome
	^ '$GS_HOME/shared/repos'
%

! Class implementation for 'GDKStoneRegistry'

!		Class methods for 'GDKStoneRegistry'

category: 'accessing'
classmethod: GDKStoneRegistry
registryHome
	| dir |
	dir := (self _configHome asFileReference / 'gsdevkit_stones' / 'registry')
		asFileReference.
	dir ensureCreateDirectory.
	^ dir
%

category: 'private'
classmethod: GDKStoneRegistry
_configHome
	^ (System gemEnvironmentVariable: 'System XDG_CONFIG_HOME')
		ifNil: [ 
			| defaultConfigHome |
			defaultConfigHome := '$HOME/.config'.
			System
				gemEnvironmentVariable: 'System XDG_CONFIG_HOME'
				put: defaultConfigHome.
			defaultConfigHome ]
%

!		Instance methods for 'GDKStoneRegistry'

category: 'accessing'
method: GDKStoneRegistry
stoneDirectorySpec
	^stoneDirectorySpec
%

category: 'accessing'
method: GDKStoneRegistry
stoneDirectorySpec: object
	stoneDirectorySpec := object
%

category: 'accessing'
method: GDKStoneRegistry
stoneName
	^stoneName
%

category: 'accessing'
method: GDKStoneRegistry
stoneName: object
	stoneName := object
%

