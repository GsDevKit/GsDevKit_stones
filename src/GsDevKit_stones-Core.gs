
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
root: aFileReferenceOrPath
	^ self new
		root: aFileReferenceOrPath asFileReference;
		yourself
%

!		Instance methods for 'GDKStoneDirectorySpec'

category: 'accessing'
method: GDKStoneDirectorySpec
backups
	| dir |
	dir := backups ifNil: [ self root / 'backups' ].
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
backups: object
	backups := object
%

category: 'accessing'
method: GDKStoneDirectorySpec
bin
	| dir |
	dir := bin ifNil: [ self root / 'bin' ].
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
bin: object
	bin := object
%

category: 'accessing'
method: GDKStoneDirectorySpec
extents
	| dir |
	dir := extents ifNil: [ self root / 'extents' ].
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
extents: object
	extents := object
%

category: 'accessing'
method: GDKStoneDirectorySpec
logs
	| dir |
	dir := logs ifNil: [ self root / 'logs' ].
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
logs: object
	logs := object
%

category: 'accessing'
method: GDKStoneDirectorySpec
root
	^root
%

category: 'initialization'
method: GDKStoneDirectorySpec
root: aFileReference
	aFileReference ensureCreateDirectory.
	root := aFileReference
%

category: 'accessing'
method: GDKStoneDirectorySpec
snapshots
	| dir |
	dir := snapshots ifNil: [ self root / 'snapshots' ].
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
snapshots: object
	snapshots := object
%

category: 'accessing'
method: GDKStoneDirectorySpec
stats
	| dir |
	dir := stats ifNil: [ self root / 'stats' ].
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
stats: object
	stats := object
%

category: 'accessing'
method: GDKStoneDirectorySpec
tranlogs
	| dir |
	dir := tranlogs ifNil: [ self root / 'tranlogs' ].
	dir ensureCreateDirectory.
	^ dir
%

category: 'accessing'
method: GDKStoneDirectorySpec
tranlogs: object
	tranlogs := object
%

