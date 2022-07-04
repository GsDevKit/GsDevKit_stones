
SET PACKAGE: GsDevKit_stones-Core
! Class Declarations
doit
(Object
	subclass: 'GDKStoneDirectorySpec'
	instVarNames: #( root backups bin extents logs stats tranlogs snapshots )
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
(Object
	subclass: 'GDKStoneRegistry'
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

category: 'initialization'
method: GDKStoneDirectorySpec
initialize
	super initialize.
	backups := 'backups'.
	bin := 'bin'.
	extents := 'extents'.
	logs := 'logs'.
	snapshots := 'snapshots'.
	stats := 'stats'.
	tranlogs := 'tranlogs'
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
root
	^ root
%

category: 'initialization'
method: GDKStoneDirectorySpec
root: aFileReference
	root := aFileReference asFileReference.
	root ensureDeleteAll.
	aFileReference ensureCreateDirectory.
	self class instVarNames
		do: [ :iv | 
			iv ~~ #'root'
				ifTrue: [ self perform: (iv , 'Dir') asSymbol ] ]
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

