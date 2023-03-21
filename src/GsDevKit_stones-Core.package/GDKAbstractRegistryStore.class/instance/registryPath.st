accessing
registryPath
	^ GDKGsDevKit_stonesBase dataHomeEnvVar, '/'
		, (self registryFile relativeTo: self class data_home) pathString