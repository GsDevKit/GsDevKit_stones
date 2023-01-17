accessing
statsDir
	| dir |
	dir := self root / self stats.
	dir ensureCreateDirectory.
	^ dir
