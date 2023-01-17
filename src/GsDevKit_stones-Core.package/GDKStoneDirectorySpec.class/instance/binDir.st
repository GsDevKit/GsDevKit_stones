accessing
binDir
	| dir |
	dir := self root / self bin.
	dir ensureCreateDirectory.
	^ dir
