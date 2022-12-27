fileformat utf8
set compile_env: 0
! ------------------- Class definition for GDK_XDGBase
expectvalue /Class
doit
(Object subclass: 'GDK_XDGBase'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.
%
expectvalue /Class
! ------------------- Class definition for GDKStonesRegistry
expectvalue /Class
doit
(GDK_XDGBase subclass: 'GDKStonesRegistry'
	instVarNames: #( name stones sessions
	                  templates)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.

%
expectvalue /Class
doit
GDK_XDGBase category: 'GsDevKit_stones-Core'
%
! ------------------- Remove existing behavior from GDK_XDGBase
removeAllMethods GDK_XDGBase
removeAllClassMethods GDK_XDGBase
! ------------------- Class methods for GDK_XDGBase
category: 'private'
classmethod: GDK_XDGBase
_applicationName
  ^ 'gsdevkit_stones'
%
category: 'private'
classmethod: GDK_XDGBase
_envName: envName defaultDir: defaultDir
  ((System gemEnvironmentVariable: 'XDG_' , envName , '_HOME')
    ifNotNil: [ :path | 
      | config_home |
      config_home := path asFileReference.
      config_home isRelativePath
        ifTrue: [ 
          "invalid specification"
          nil ]
        ifFalse: [ ^ config_home / self _applicationName ] ])
    ifNil: [ ^ defaultDir asFileReference / self _applicationName ]
%
category: 'accessing'
classmethod: GDK_XDGBase
cache_home
  ^ (self _envName: 'CACHE' defaultDir: '$HOME/.cache')
    ifNotNil: [ :dir | 
      dir ensureCreateDirectory.
      dir ]
%
category: 'accessing'
classmethod: GDK_XDGBase
config_home
  ^ (self _envName: 'CONFIG' defaultDir: '$HOME/.config')
    ifNotNil: [ :dir | 
      dir ensureCreateDirectory.
      dir ]
%
category: 'accessing'
classmethod: GDK_XDGBase
data_home
  ^ (self _envName: 'DATA' defaultDir: '$HOME/.local/share')
    ifNotNil: [ :dir | 
      dir ensureCreateDirectory.
      dir ]
%
category: 'instance creation'
classmethod: GDK_XDGBase
new

	^(super new) initialize
%
category: 'accessing'
classmethod: GDK_XDGBase
state_home
  ^ (self _envName: 'STATE' defaultDir: '$HOME/.local/state')
    ifNotNil: [ :dir | 
      dir ensureCreateDirectory.
      dir ]
%
! ------------------- Instance methods for GDK_XDGBase
category: 'initialization'
method: GDK_XDGBase
initialize
  
%
set compile_env: 0
! ------------------- Class definition for GDKRegistry
expectvalue /Class
doit
(Dictionary subclass: 'GDKRegistry'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.

%
expectvalue /Class
doit
GDKRegistry category: 'GsDevKit_stones-Core'
%
! ------------------- Remove existing behavior from GDKRegistry
removeAllMethods GDKRegistry
removeAllClassMethods GDKRegistry
! ------------------- Class methods for GDKRegistry
category: 'accessing'
classmethod: GDKRegistry
config_home
  ^ GDK_XDGBase config_home
%
category: 'accessing'
classmethod: GDKRegistry
data_home
  | dir |
  dir := GDK_XDGBase data_home / 'registry'.
  dir ensureCreateDirectory.
  ^ dir
%
category: 'instance creation'
classmethod: GDKRegistry
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
%
! ------------------- Instance methods for GDKRegistry
set compile_env: 0
! ------------------- Class definition for GDKStoneDirectorySpec
expectvalue /Class
doit
(GDK_XDGBase subclass: 'GDKStoneDirectorySpec'
	instVarNames: #( root backups bin
	                  extents logs stats tranlogs
	                  snapshots projectsHome product gemstone)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.

%
expectvalue /Class
doit
GDKStoneDirectorySpec category: 'GsDevKit_stones-Core'
%
! ------------------- Remove existing behavior from GDKStoneDirectorySpec
removeAllMethods GDKStoneDirectorySpec
removeAllClassMethods GDKStoneDirectorySpec
! ------------------- Class methods for GDKStoneDirectorySpec
category: 'instance creation'
classmethod: GDKStoneDirectorySpec
new
	^ super new initialize
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
! ------------------- Instance methods for GDKStoneDirectorySpec
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
set compile_env: 0
! ------------------- Class definition for GDK_homeStoneDirectorySpec
expectvalue /Class
doit
(GDKStoneDirectorySpec subclass: 'GDK_homeStoneDirectorySpec'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #()
)
		category: 'GsDevKit_stones-Core';
		immediateInvariant.
true.

%
expectvalue /Class
doit
GDK_homeStoneDirectorySpec category: 'GsDevKit_stones-Core'
%
! ------------------- Remove existing behavior from GDK_homeStoneDirectorySpec
removeAllMethods GDK_homeStoneDirectorySpec
removeAllClassMethods GDK_homeStoneDirectorySpec
! ------------------- Class methods for GDK_homeStoneDirectorySpec
category: 'instance creation'
classmethod: GDK_homeStoneDirectorySpec
_defaultProjectsHome
	^ '$GS_HOME/shared/repos'
%
category: 'instance creation'
classmethod: GDK_homeStoneDirectorySpec
root: aFileReferenceOrPath gemstone: gemstonePath
	"if aFileReferenceOrPath exists, it will be deleted and recreated ... empty"

	^ self
		root: aFileReferenceOrPath asFileReference
		projectsHome: self _defaultProjectsHome
		gemstone: gemstonePath
%
! ------------------- Instance methods for GDK_homeStoneDirectorySpec
set compile_env: 0
doit
GDKStonesRegistry category: 'GsDevKit_stones-Core'
%
! ------------------- Remove existing behavior from GDKStonesRegistry
removeAllMethods GDKStonesRegistry
removeAllClassMethods GDKStonesRegistry
! ------------------- Class methods for GDKStonesRegistry
category: 'instance creation'
classmethod: GDKStonesRegistry
newNamed: registryName
  ^ self new
    name: registryName;
    yourself
%
category: 'accessing'
classmethod: GDKStonesRegistry
registry_home
  | dir |
  dir := (self data_home asFileReference / 'registry')
    asFileReference.
  dir ensureCreateDirectory.
  ^ dir
%
! ------------------- Instance methods for GDKStonesRegistry
category: 'initialization'
method: GDKStonesRegistry
initialize
  super initialize.
  sessions := Dictionary new.
  templates := Dictionary new.
  stones := Dictionary new
%
category: 'accessing'
method: GDKStonesRegistry
name
  ^ name
%
category: 'accessing'
method: GDKStonesRegistry
name: aString
  name := aString
%
category: 'accessing'
method: GDKStonesRegistry
sessions
  ^ sessions
%
category: 'accessing'
method: GDKStonesRegistry
stones
  ^ stones
%
category: 'accessing'
method: GDKStonesRegistry
templates
  ^ templates
%
category: 'accessing'
method: GDKStonesRegistry
registryFile
	^ self class registry_home / self name , 'ston'
%
