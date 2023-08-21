accessing
todeHomeDirectory: todeHomePath templatesDir: sourceTemplatesDir populate: populate
	"The tode shared directory is equivalent to the $GS_HOME/sys/local directory in GsDevKit_home. 
		The directories created in this method are required for the proper functioning of a tODE client."

	| todeHomeDir todeTemplatesDir |
	todeHomeDir := todeHomePath asFileReference.
	self todeHome: todeHomeDir pathString.
	(todeHomeDir exists not or: [ populate ])
		ifTrue: [ 
			todeHomeDir ensureCreateDirectory.
			(todeHomeDir / 'sys') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'default') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'default' / 'server') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'default' / 'server' / 'gemstone')
				ensureCreateDirectory.

			(todeHomeDir / 'sys' / 'default' / 'server' / 'home') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'default' / 'server' / 'home' / 'tode') ensureCreateDirectory.
"copy GsDevKit_stones/todeHome/tode"
			(todeHomeDir / 'sys' / 'default' / 'server' / 'home' / 'utils' ) ensureCreateDirectory.
"copy GsDevKit_stones/todeHome/utils"

			(todeHomeDir / 'sys' / 'default' / 'server' / 'projects')
				ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'default' / 'server' / 'stones') ensureCreateDirectory.

			(todeTemplatesDir := todeHomeDir / 'sys' / 'default' / 'server' / 'templates')
				ensureCreateDirectory.
			sourceTemplatesDir files
				do: [ :templateFile | 
					templateFile extension = 'ston'
						ifTrue: [ templateFile copyTo: todeTemplatesDir / templateFile basename ] ].

			(todeHomeDir / 'sys' / 'default' / 'server' / 'upgrade')
				ensureCreateDirectory.

			(todeHomeDir / 'sys' / 'local') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'gemstone') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'home') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'projects') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'sessions') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'templates')
				ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'upgrade') ensureCreateDirectory.

			self class
				symbolicLink: todeHomeDir / 'sys' / 'local' / 'server' / 'stones'
				linkName: todeHomeDir / 'sys' / 'stones' ]