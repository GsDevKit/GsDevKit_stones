accessing
extentsDir
	| dir |
	dir := self root / self extents.
	dir ensureCreateDirectory.
	^ dir
