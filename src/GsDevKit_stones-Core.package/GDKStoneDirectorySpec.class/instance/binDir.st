as yet unspecified
binDir
	| dir |
	dir := self root / self bin.
	dir ensureCreateDirectory.
	^ dir
