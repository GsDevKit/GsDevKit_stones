accessing
registryPath
	^ GDKGsDevKit_stonesBase dataHomeEnvVar
		, (self registryFile relativeTo: GDK_XDGBase data_home) pathString