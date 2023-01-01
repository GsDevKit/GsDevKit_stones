as yet unspecified
registryHome
	| dir |
	dir := (self _configHome asFileReference / 'gsdevkit_stones' / 'registry')
		asFileReference.
	dir ensureCreateDirectory.
	^ dir
