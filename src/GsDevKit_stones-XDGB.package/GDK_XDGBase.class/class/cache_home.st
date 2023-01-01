xdgb accessing
cache_home
	| fileRef tmps |
	tmps := SessionTemps current.
	(tmps at: #'GDK_XDGBase_cache_home' otherwise: nil)
		ifNotNil: [ :cachedRef | ^ cachedRef ].
	fileRef := self _envName: 'CACHE' defaultDir: '$HOME/.cache' asFileReference pathString.
	fileRef ensureCreateDirectory.
	^ tmps at: #'GDK_XDGBase_cache_home' put: fileRef