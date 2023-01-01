xdgb accessing
data_home
	| fileRef tmps |
	tmps := SessionTemps current.
	(tmps at: #'GDK_XDGBase_data_home' otherwise: nil)
		ifNotNil: [ :cachedRef | ^ cachedRef ].
	fileRef := self _envName: 'DATA' defaultDir: '$HOME/.local/share' asFileReference pathString.
	fileRef ensureCreateDirectory.
	^ tmps at: #'GDK_XDGBase_data_home' put: fileRef