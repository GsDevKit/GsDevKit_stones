accessing
tranlogsDir
	| dir |
	dir := self root / self tranlogs.
	dir ensureCreateDirectory.
	^ dir
