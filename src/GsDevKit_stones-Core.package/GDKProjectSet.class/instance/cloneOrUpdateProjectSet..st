installation
cloneOrUpdateProjectSet: gitRootPath
	self loadSpecs
		keysDo: [ :projectName | self cloneOrUpdateProject: projectName in: gitRootPath ]