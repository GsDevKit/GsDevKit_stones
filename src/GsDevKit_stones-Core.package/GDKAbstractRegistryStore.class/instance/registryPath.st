accessing
registryPath
	^ '$' , GDKGsDevKit_stonesBase dataHomeEnvVar , '/'
		, (self registryFile relativeTo: self class base_data_home) fullName