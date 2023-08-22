xdgb accessing
config_home
	| fileRef tmps |
	tmps := SessionTemps current.
	(tmps at: #'GDK_XDGBase_config_home' otherwise: nil)
		ifNotNil: [ :cachedRef | ^ cachedRef ].
	fileRef := self _envName: 'CONFIG' defaultDir: '$HOME/.config' asFileReference fullName.
	fileRef ensureCreateDirectory.
	^ tmps at: #'GDK_XDGBase_config_home' put: fileRef