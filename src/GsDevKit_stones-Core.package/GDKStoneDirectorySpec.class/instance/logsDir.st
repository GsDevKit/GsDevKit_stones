as yet unspecified
logsDir
	| dir |
	dir := self root / self logs.
	dir ensureCreateDirectory.
	^ dir
