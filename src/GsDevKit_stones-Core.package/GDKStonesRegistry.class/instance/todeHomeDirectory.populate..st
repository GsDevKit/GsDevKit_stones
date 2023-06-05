accessing
todeHomeDirectory: todeHomePath populate: populate
	"The tode shared directory is equivalent to the $GS_HOME/sys/local directory in GsDevKit_home. 
		The directories created in this method are required for the proper functioning of a tODE client."

	| todeHomeDir |
	todeHomeDir := todeHomePath asFileReference.
	self todeHome: todeHomeDir pathString.
	(todeHomeDir exists not or: [ populate ])
		ifTrue: [ 
			todeHomeDir ensureCreateDirectory.
			(todeHomeDir / 'sys') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'gemstone') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'home') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'monticello')
				ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'projects') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'stones') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'templates')
				ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'server' / 'upgrade') ensureCreateDirectory.
			(todeHomeDir / 'sys' / 'local' / 'sessions') ensureCreateDirectory.
			self class
				symbolicLink: todeHomeDir / 'sys' / 'local' / 'server' / 'stones'
				linkName: todeHomeDir / 'sys' / 'stones' ]