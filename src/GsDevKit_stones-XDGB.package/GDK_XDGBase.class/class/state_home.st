xdgb accessing
state_home
	| fileRef tmps |
	tmps := SessionTemps current.
	(tmps at: #'GDK_XDGBase_state_home' otherwise: nil)
		ifNotNil: [ :cachedRef | ^ cachedRef ].
	fileRef := self _envName: 'STATE' defaultDir: '$HOME/.local/state' asFileReference fullName.
	fileRef ensureCreateDirectory.
	^ tmps at: #'GDK_XDGBase_state_home' put: fileRef