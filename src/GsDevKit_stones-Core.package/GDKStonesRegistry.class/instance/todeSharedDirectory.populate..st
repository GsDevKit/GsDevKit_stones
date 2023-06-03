accessing
todeSharedDirectory: todeSharedDirPath populate: populate
	"The tode shared directory is equivalent to the $GS_HOME/sys/local directory in GsDevKit_home"

	| todeSharedDir |
	todeSharedDir := todeSharedDirPath asFileReference.
	self todeSharedDirectory: todeSharedDirPath.
	todeSharedDir ensureCreateDirectory.
	(todeSharedDir / 'server') ensureCreateDirectory.
	(todeSharedDir / 'server' / 'projects') ensureCreateDirectory.
	(todeSharedDir / 'server' / 'stones') ensureCreateDirectory.
	(todeSharedDir / 'sessions') ensureCreateDirectory