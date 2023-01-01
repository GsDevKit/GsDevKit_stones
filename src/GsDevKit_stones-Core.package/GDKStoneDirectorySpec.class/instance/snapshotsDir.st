as yet unspecified
snapshotsDir
	| dir |
	dir := self root / self snapshots.
	dir ensureCreateDirectory.
	^ dir
