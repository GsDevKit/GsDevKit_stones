Class {
	#name : 'GDKStoneDirectorySpec',
	#superclass : 'Object',
	#instVars : [
		'root',
		'backups',
		'bin',
		'extents',
		'logs',
		'stats',
		'tranlogs',
		'snapshots'
	],
	#category : 'GsDevKit_stones-Core'
}

{ #category : 'instance creation' }
GDKStoneDirectorySpec class >> root: aFileReferenceOrPath [
	^ self new
		root: aFileReferenceOrPath asFileReference;
		yourself
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> backups [
	| dir |
	dir := backups ifNil: [ self root / 'backups' ].
	dir ensureCreateDirectory.
	^ dir
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> backups: object [
	backups := object
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> bin [
	| dir |
	dir := bin ifNil: [ self root / 'bin' ].
	dir ensureCreateDirectory.
	^ dir
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> bin: object [
	bin := object
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> extents [
	| dir |
	dir := extents ifNil: [ self root / 'extents' ].
	dir ensureCreateDirectory.
	^ dir
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> extents: object [
	extents := object
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> logs [
	| dir |
	dir := logs ifNil: [ self root / 'logs' ].
	dir ensureCreateDirectory.
	^ dir
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> logs: object [
	logs := object
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> root [
	^root
]

{ #category : 'initialization' }
GDKStoneDirectorySpec >> root: aFileReference [
	aFileReference ensureCreateDirectory.
	root := aFileReference
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> snapshots [
	| dir |
	dir := snapshots ifNil: [ self root / 'snapshots' ].
	dir ensureCreateDirectory.
	^ dir
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> snapshots: object [
	snapshots := object
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> stats [
	| dir |
	dir := stats ifNil: [ self root / 'stats' ].
	dir ensureCreateDirectory.
	^ dir
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> stats: object [
	stats := object
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> tranlogs [
	| dir |
	dir := tranlogs ifNil: [ self root / 'tranlogs' ].
	dir ensureCreateDirectory.
	^ dir
]

{ #category : 'accessing' }
GDKStoneDirectorySpec >> tranlogs: object [
	tranlogs := object
]
