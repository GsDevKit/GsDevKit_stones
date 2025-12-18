installation
cloneOrUpdateProjectSet: gitRootPath remoteName: remoteName flag: flag pull: pull
	self loadSpecs
		keysDo: [ :projectName | self cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath  flag: flag pull: pull ]