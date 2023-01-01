as yet unspecified
registryPath
	^ '$XDG_DATA_HOME/'
		, (self registryFile relativeTo: GDK_XDGBase data_home) pathString