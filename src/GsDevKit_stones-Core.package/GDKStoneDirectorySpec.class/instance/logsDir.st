accessing
logsDir
	| dir |
	dir := self root / self logs.
	dir ensureCreateDirectory.
	^ dir
