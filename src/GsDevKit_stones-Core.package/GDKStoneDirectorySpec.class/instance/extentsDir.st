as yet unspecified
extentsDir
	| dir |
	dir := self root / self extents.
	dir ensureCreateDirectory.
	^ dir
