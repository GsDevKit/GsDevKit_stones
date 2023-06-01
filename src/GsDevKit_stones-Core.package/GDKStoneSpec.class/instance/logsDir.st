accessing
logsDir
	| dir |
	dir := self rootDir / self stoneDirectorySpec logs.
	dir ensureCreateDirectory.
	^ dir