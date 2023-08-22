installation
cloneOrUpdateProjectSet: gitRootPath pull: pull
	self loadSpecs
		keysDo: [ :projectName | self cloneOrUpdateProject: projectName in: gitRootPath pull: pull ]